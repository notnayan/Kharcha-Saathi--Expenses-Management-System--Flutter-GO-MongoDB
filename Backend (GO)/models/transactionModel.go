package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Transaction struct {
	ID          primitive.ObjectID `bson:"_id,omitempty"`
	UserID      primitive.ObjectID `bson:"userID,omitempty"`
	Type        string             `bson:"type,omitempty"`
	Amount      float64            `bson:"amount,omitempty"`
	Date        time.Time          `bson:"date,omitempty"`
	Description string             `bson:"description,omitempty"`
}
