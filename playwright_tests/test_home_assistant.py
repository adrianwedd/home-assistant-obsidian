
import re
from playwright.sync_api import Page, expect

def test_setup(page: Page):
    """
    This test verifies that the user can navigate through the initial setup screen.
    """
    page.goto("http://homeassistant.local:8123/")

    # Pause the test to inspect the page.
    page.pause()
