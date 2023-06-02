package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Expense struct {
	ID          primitive.ObjectID `bson:"_id, omitempty"`
	Description string             `json:"description" validate:"omitempty, min=10, max=1000"`
	Amount      int                `json:"amount" validate:"omitempty"`
	Date        string             `json:"date" validate:"omitempty"`
}
