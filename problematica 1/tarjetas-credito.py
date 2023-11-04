import sqlite3
import json

conn = sqlite3.connect('itbank.db')
cursor = conn.cursor()

# Abre el archivo JSON
with open('tarjetas.json') as json_file:
    data = json.load(json_file)

# Itera sobre los datos del JSON y realiza inserciones en la base de datos
for tarjeta in data:
    cursor.execute("INSERT INTO Tarjeta (Numero, CVV, FechaOtorgamiento, FechaExpiracion, TipoTarjeta) VALUES (?, ?, ?, ?, ?)",
                   (str(tarjeta['Numero']), tarjeta['CVV'], tarjeta['FechaOtorgamiento'], tarjeta['FechaExpiracion'], tarjeta['TipoTarjeta']))
    conn.commit()
    
# for tarjeta in data:
#     cursor.execute("INSERT INTO Tarjeta (Numero, CVV, FechaOtorgamiento, FechaExpiracion, TipoTarjeta, TipoClienteID, TipoCuentaID) VALUES (?, ?, ?, ?, ?, ?, ?)",
#                    (tarjeta['Numero'], tarjeta['CVV'], tarjeta['FechaOtorgamiento'], tarjeta['FechaExpiracion'], tarjeta['TipoTarjeta'], tarjeta['TipoClienteID'], tarjeta['TipoCuentaID']))
#     conn.commit()


# Cierra la conexión a la base de datos
conn.close()
