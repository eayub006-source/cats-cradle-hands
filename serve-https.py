from __future__ import annotations

import argparse
import functools
import http.server
import os
import ssl
from pathlib import Path


def build_server(root: Path, port: int, certfile: Path, keyfile: Path) -> http.server.ThreadingHTTPServer:
    handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(root))
    server = http.server.ThreadingHTTPServer(("0.0.0.0", port), handler)

    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.load_cert_chain(certfile=str(certfile), keyfile=str(keyfile))
    server.socket = context.wrap_socket(server.socket, server_side=True)
    return server


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Serve the Cat's Cradle folder over HTTPS.")
    parser.add_argument("--port", type=int, default=8443)
    parser.add_argument("--cert", required=True)
    parser.add_argument("--key", required=True)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    root = Path(__file__).resolve().parent
    certfile = Path(args.cert)
    keyfile = Path(args.key)

    os.chdir(root)
    server = build_server(root, args.port, certfile, keyfile)
    print(f"Serving HTTPS on https://localhost:{args.port}/")
    print("Press Ctrl+C to stop.")
    server.serve_forever()


if __name__ == "__main__":
    main()