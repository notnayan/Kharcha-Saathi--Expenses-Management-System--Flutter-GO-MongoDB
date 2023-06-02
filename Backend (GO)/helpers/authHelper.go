package helpers

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

const (
	accessTokenDuration  = 24 * time.Hour     // Access token duration
	refreshTokenDuration = 7 * 24 * time.Hour // Refresh token duration
	secretKey            = "secret-key"       // Secret key used for signing tokens
)

func HashPassword(password string) string {
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		panic(err)
	}
	return string(hash)
}

func VerifyPassword(userPassword string, providePassword string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(userPassword), []byte(providePassword))
	return !(err != nil)
}

func GenerateAccessToken(userID string) (string, error) {
	expirationTime := time.Now().Add(accessTokenDuration)
	claims := jwt.MapClaims{
		"sub": userID,
		"exp": expirationTime.Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signedToken, err := token.SignedString([]byte(secretKey))
	if err != nil {
		return "", err
	}
	return signedToken, nil
}

func GenerateRefreshToken(userID string) (string, error) {
	expirationTime := time.Now().Add(refreshTokenDuration)
	claims := jwt.MapClaims{
		"sub": userID,
		"exp": expirationTime.Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signedToken, err := token.SignedString([]byte(secretKey))
	if err != nil {
		return "", err
	}
	return signedToken, nil
}

func RefreshTokens(refreshToken string) (string, string, error) {
	// Parse the refresh token
	token, err := jwt.ParseWithClaims(refreshToken, &jwt.StandardClaims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(secretKey), nil
	})
	if err != nil {
		return "", "", err
	}

	// Verify that the token is valid and not expired
	if !token.Valid {
		return "", "", jwt.ErrInvalidKey
	}

	// Get the user ID and role from the refresh token
	claims := token.Claims.(*jwt.StandardClaims)
	userID := claims.Subject

	// Generate new access and refresh tokens with the user role
	newAccessToken, err := GenerateAccessToken(userID)
	if err != nil {
		return "", "", err
	}
	newRefreshToken, err := GenerateRefreshToken(userID)
	if err != nil {
		return "", "", err
	}

	return newAccessToken, newRefreshToken, nil
}

func IsAuthenticated(c *gin.Context) bool {

	// Check if the Authorization header is set
	authHeader := c.Request.Header.Get("Authorization")
	if authHeader == "" {
		return false
	}

	// Check if the Authorization header is in the correct format
	tokenString := strings.Split(authHeader, "Bearer ")[1]
	token, err := jwt.ParseWithClaims(tokenString, &jwt.StandardClaims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(secretKey), nil
	})

	if err != nil {
		return false
	}

	// Check if the token is valid
	if !token.Valid {
		return false
	}

	return true
}

type AccessTokenClaims struct {
	jwt.StandardClaims
	Role string `json:"role"`
}

func GetIdFromAccessToken(c *gin.Context) string {
	authHeader := c.Request.Header.Get("Authorization")

	// Check if the Authorization header is empty
	if authHeader == "" {
		return "Auth Header is empty"
	}

	tokenString := strings.Split(authHeader, "Bearer ")[1]
	tokenClaims := &AccessTokenClaims{}
	_, err := jwt.ParseWithClaims(tokenString, tokenClaims, func(token *jwt.Token) (interface{}, error) {
		return []byte(secretKey), nil
	})
	if err != nil {
		return ""
	}
	return tokenClaims.Subject
}

func VerifyGoogleToken(ctx context.Context, tokenID string) (string, error) {
	// Verify the token with Google
	// First, create a new HTTP client
	client := &http.Client{}

	// Then, create a new HTTP request to the Google token verification endpoint
	req, err := http.NewRequestWithContext(ctx, "GET", "https://oauth2.googleapis.com/tokeninfo", nil)
	if err != nil {
		return "", err
	}

	// Add the token as access token
	req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", tokenID))

	// Send the request
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	// Check if the response status code is 200
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("invalid token")
	}

	// Decode the response body
	var data map[string]interface{}
	err = json.NewDecoder(resp.Body).Decode(&data)
	if err != nil {
		return "", err
	}

	// Check if the token is valid
	if data["error"] != nil {
		return "", fmt.Errorf("invalid token")
	}

	// Check if the token is expired
	exp, err := strconv.ParseInt(data["exp"].(string), 10, 64)
	if err != nil {
		return "", err
	}
	if time.Now().Unix() > exp {
		return "", fmt.Errorf("token expired")
	}

	// Get the user ID and email from the token
	userID := data["sub"].(string)
	email := data["email"].(string)

	// Check if the user exists in the database
	exists := CheckEmailExists(email)

	// If the user doesn't exist, create a new user
	if !exists {
		err = CreateUser(userID, email)
		if err != nil {
			return "", err
		}
	}

	return email, nil
}
