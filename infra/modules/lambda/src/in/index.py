import socket
import urllib.request

def lambda_handler(event, context):
    url = "https://www.google.com"

    # IPv4 のみを使用するように設定
    def force_ipv4():
        """Force urllib to use IPv4"""
        orig_getaddrinfo = socket.getaddrinfo
        def new_getaddrinfo(*args, **kwargs):
            return [entry for entry in orig_getaddrinfo(*args, **kwargs) if entry[0] == socket.AF_INET]
        socket.getaddrinfo = new_getaddrinfo

    force_ipv4()

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
