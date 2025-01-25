;; IoT Integration Contract

(define-map iot-data
    { product-id: uint, timestamp: uint }
    { temperature: int, humidity: int, location: (string-ascii 50) }
)

(define-public (record-iot-data (product-id uint) (temperature int) (humidity int) (location (string-ascii 50)))
    (let
        ((timestamp block-height))
        (map-set iot-data
            { product-id: product-id, timestamp: timestamp }
            { temperature: temperature, humidity: humidity, location: location }
        )
        (ok timestamp)
    )
)

(define-read-only (get-iot-data (product-id uint) (timestamp uint))
    (map-get? iot-data { product-id: product-id, timestamp: timestamp })
)

(define-read-only (get-latest-iot-data (product-id uint))
    (map-get? iot-data { product-id: product-id, timestamp: block-height })
)

