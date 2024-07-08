::cd ..
:: Initiate permissions and folder creations
mkdir scripts\models
icacls scripts\models /grant Everyone:(OI)(CI)F

mkdir scripts\db
icacls scripts\db /grant Everyone:(OI)(CI)F
