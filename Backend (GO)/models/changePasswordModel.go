package models

type ChangePassword struct {
	OldPassword string `json:"oldPassword" validate:"required, min=8, max=30"`
	NewPassword string `json:"newPassword" validate:"required, min=8, max=30"`
}
type ChangeInitialCurrency struct {
	InitialCurrency string `json:"initialCurrency" validate:"required"`
}
type ChangeInitialBalance struct {
	InitialBalance string `json:"initialBalance" validate:"required"`
}
