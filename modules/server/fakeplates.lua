print('^4 [kmack_lib] ^9Loaded Fakeplates System^7')


















--- we use the database to store the plates, so if players put it in a garage you can utilize it later
MySQL.query('CREATE TABLE IF NOT EXISTS kmack_fakeplates (plate VARCHAR(10), fakeplate VARCHAR(10))')