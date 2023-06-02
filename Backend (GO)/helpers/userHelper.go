package helpers

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"kharchasathi.com/database"
	"kharchasathi.com/models"
)

var userCollection = database.OpenCollection(database.Client, "users")
var transactionCollection = database.OpenCollection(database.Client, "transactions")

func CheckEmailExists(email string) bool {
	var user models.User
	err := userCollection.FindOne(context.Background(), bson.M{"email": email}).Decode(&user)
	return err == nil
}

func CreateUser(userID string, email string) error {
	var ctx, cancel = context.WithTimeout(context.Background(), 100*time.Second)
	defer cancel()

	user := models.User{
		ID:       primitive.NewObjectID(),
		Email:    email,
		Password: "",
	}

	_, err := userCollection.InsertOne(ctx, user)
	if err != nil {
		return err
	}

	return nil
}

func GetUserByEmail(email string) (models.User, error) {
	var user models.User
	err := userCollection.FindOne(context.Background(), bson.M{"email": email}).Decode(&user)
	if err != nil {
		return user, err
	}

	return user, nil
}
