::cd ..
:: Initiate permissions and folder creations
:: mkdir scripts\models
:: icacls scripts\models /grant Everyone:(OI)(CI)F

mkdir docker\db
icacls docker\db /grant Everyone:(OI)(CI)F
