package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	ID       primitive.ObjectID `bson:"_id, omitempty"`
	Email    string             `json:"email" validate:"required, email"`
	Password string             `json:"password" validate:"required, min=8, max=30"`
	Currency string             `json:"initialCurrency" validate:"required"`
	Balance  int                `json:"balance" validate:"omitempty"`
}

type UserLogin struct {
	Email    string `json:"email" validate:"required, email"`
	Password string `json:"password" validate:"required, min=8, max=30"`
}
