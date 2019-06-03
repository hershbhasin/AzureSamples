$endpoint = "https://api.powerbi.com/beta/f66b6bd3-ebc2-4f54-8769-d22858de97c5/datasets/aefd39a9-383e-4384-9ea3-cefa3c622b1d/rows?key=jB5jSs3Q3CJrT2ZdEsQiNsS%2FryvZARqxlEW6NDM3k9hFwyK7sHK01NEx4FGjmtvAxkoFFMMk4TT0fV7%2BiNAeqg%3D%3D"
$payload = @{
"Value" = 40
"Category" = "Cat A"
}
Invoke-RestMethod -Method Post -Uri "$endpoint" -Body (ConvertTo-Json @($payload))