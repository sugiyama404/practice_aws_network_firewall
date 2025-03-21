import urllib.request

def lambda_handler(event, context):
    url = "https://www.google.com"
    try:
        with urllib.request.urlopen(url, timeout=5) as response:
            status_code = response.getcode()
            return {
                "statusCode": 200,
                "body": f"Success, status code: {status_code}"
            }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Failed to connect: {str(e)}"
        }
