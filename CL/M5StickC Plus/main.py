from m5stack import lcd
import utime
import wifiCfg
import hat
import urequests
import ujson
import gc

# チャネル(bucket)
CHANNEL = "CQCH1"
# measurement
MEASUREMENT = "M5StickC"

#データサーバのアドレス
DATA_SERVER = "http://192.168.3.3:8000/data/" + CHANNEL + "/" + MEASUREMENT

#データ送信間隔(秒)
INTERVAL = 60

#画面クリア
lcd.clear()
lcd.setRotation(1)
lcd.setCursor(0, 0)

# WiFi接続
wifiCfg.autoConnect()

header = {'Content-Type' : 'application/json'}

# HAT ENV IIを使って環境データを取得してデータ・サーバに送信する。
hat_env2 = hat.get(hat.ENV2)
while True:
        # 気温、湿度、気圧を取得
        temp = hat_env2.temperature
        hum = hat_env2.humidity
        pre = hat_env2.pressure

        # 表示
        lcd.clear()
        lcd.setCursor(0, 0)
        wait_ms(2)
        lcd.println('Temp:' + str(("%.2f"%temp)) + ' deg.')
        lcd.println('Humidity:' + str(("%.2f"%hum)) + '%')
        lcd.println('Pres:' + str(("%.2f"%pre)) + ' hPa')
        wait(1)

        # データ・サーバにデータを送信
        dp = {
            "source":"M5StickC Plus",
            "data":[{"temperature":temp},{"pressure":pre},{"humidity":hum}]
            }
 
        #resp = urequests.post(DATA_SERVER, data = {"source":"A"}, headers = header)
        resp = urequests.post(DATA_SERVER, data = ujson.dumps(dp).encode("utf-8"), headers = header)
        lcd.println(str(resp.status_code))
 
        gc.collect()

        wait(INTERVAL)
 
