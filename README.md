# docker-warp-socks5
![Docker Pulls](https://img.shields.io/docker/pulls/qiqiworld/warp-socks5)  

```bash
docker run -d -p 40000:40000 qiqiworld/warp-socks5
```

## Note
This image exposes just a SOCKS5 proxy, not a mixed proxy server.

You **CANNOT** use this server as a HTTP/HTTPS proxy.

## Usage
### Python
First, install the requests library.

```bash
pip install requests[socks]
```

Then, you can access the proxy server with the following code.

```python
import requests
proxies = {
    'http': 'socks5://127.0.0.1:40000/',
    'https': 'socks5://127.0.0.1:40000/',
}
response = requests.get('https://www.cloudflare.com/cdn-cgi/trace', proxies=proxies)
print(response.text)
```
