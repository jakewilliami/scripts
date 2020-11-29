using HTTP, HttpCommon

url = "https://www.nzism.gcsb.govt.nz/ism-document/"

response = HTTP.request("GET", url)

println(response.status)
