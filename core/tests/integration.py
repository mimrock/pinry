from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from threading import Thread

from django.conf import settings
from django.test import TestCase

from core.models import Image
from tests.image_factory import image_bytes


def create_image_handler(payload, requests_seen):
    class ImageHandler(BaseHTTPRequestHandler):
        def do_GET(self):
            requests_seen.append({
                "path": self.path,
                "referer": self.headers.get("Referer"),
                "user_agent": self.headers.get("User-Agent"),
            })

            if self.path == "/redirect":
                self.send_response(302)
                self.send_header("Location", "/image.png")
                self.end_headers()
                return

            if self.path == "/image.png":
                self.send_response(200)
                self.send_header("Content-Type", "image/png")
                self.send_header("Content-Length", str(len(payload)))
                self.end_headers()
                self.wfile.write(payload)
                return

            self.send_error(404)

        def log_message(self, format, *args):
            pass

    return ImageHandler


class RequestsIntegrationTest(TestCase):
    def test_create_image_from_local_http_redirect(self):
        requests_seen = []
        handler = create_image_handler(image_bytes(), requests_seen)
        server = ThreadingHTTPServer(("127.0.0.1", 0), handler)
        thread = Thread(target=server.serve_forever, daemon=True)
        thread.start()

        referer = "http://pinry.test/board/"
        image_url = "http://127.0.0.1:{}/redirect".format(server.server_port)
        try:
            image = Image.objects.create_for_url(image_url, referer=referer)
        finally:
            server.shutdown()
            server.server_close()
            thread.join(timeout=5)

        self.assertIsNotNone(image)
        self.assertEqual(image.thumbnail_set.count(), len(settings.IMAGE_SIZES))
        self.assertEqual(
            [request["path"] for request in requests_seen],
            ["/redirect", "/image.png"],
        )
        self.assertTrue(all(request["referer"] == referer for request in requests_seen))
        self.assertTrue(all(request["user_agent"] for request in requests_seen))
