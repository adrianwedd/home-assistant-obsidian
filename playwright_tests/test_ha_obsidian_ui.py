import pytest
import os
from dotenv import load_dotenv
from playwright.sync_api import Page, expect

load_dotenv()

HA_USERNAME = os.getenv("HA_USERNAME")
HA_PASSWORD = os.getenv("HA_PASSWORD")
HA_URL = os.getenv("HA_URL")
OBSIDIAN_ADDON_SLUG = "c9a82807_obsidian"

def login_to_home_assistant(page: Page):
    page.goto(HA_URL)
    page.wait_for_load_state('domcontentloaded')
    expect(page).to_have_title("Home Assistant")

    # Fill in username and password
    page.locator("input[name='username']").fill(HA_USERNAME)
    page.locator("input[name='password']").fill(HA_PASSWORD)
    page.screenshot(path="playwright_tests/screenshots/login_page_before_click.png")
    expect(page.get_by_role("button", name="LOG IN")).to_be_enabled()
    page.get_by_role("button", name="LOG IN").click()

    # Wait for the main dashboard to load
    page.wait_for_selector("home-assistant")
    expect(page.locator("home-assistant")).to_be_visible()
    # Wait for the sidebar to be visible and interactive
    expect(page.locator("ha-sidebar")).to_be_visible()

@pytest.fixture(scope="session")
def logged_in_page(playwright):
    browser = playwright.chromium.launch()
    page = browser.new_page()
    login_to_home_assistant(page)
    yield page
    browser.close()

def test_addon_info_page(logged_in_page: Page):
    page = logged_in_page
    page.goto(f"{HA_URL}/hassio/addon/{OBSIDIAN_ADDON_SLUG}/info")
    expect(page.locator("ha-card")).to_be_visible()
    page.screenshot(path="playwright_tests/screenshots/addon_info_page.png")
    expect(page.locator("ha-card h1")).to_have_text("Obsidian")
    expect(page.locator("ha-card").filter(has_text="Version")).to_be_visible()

def test_addon_documentation_page(logged_in_page: Page):
    page = logged_in_page
    page.goto(f"{HA_URL}/hassio/addon/{OBSIDIAN_ADDON_SLUG}/documentation")
    expect(page.locator("ha-card")).to_be_visible()
    page.screenshot(path="playwright_tests/screenshots/addon_documentation_page.png")
    expect(page.locator("ha-card h1")).to_have_text("Documentation")
    expect(page.locator("ha-markdown")).to_be_visible()

def test_addon_config_page(logged_in_page: Page):
    page = logged_in_page
    page.goto(f"{HA_URL}/hassio/addon/{OBSIDIAN_ADDON_SLUG}/config")
    expect(page.locator("ha-card")).to_be_visible()
    page.screenshot(path="playwright_tests/screenshots/addon_config_page.png")
    expect(page.locator("ha-card h1")).to_have_text("Configuration")
    expect(page.locator("ha-form")).to_be_visible()

def test_addon_logs_page(logged_in_page: Page):
    page = logged_in_page
    page.goto(f"{HA_URL}/hassio/addon/{OBSIDIAN_ADDON_SLUG}/logs")
    expect(page.locator("ha-card")).to_be_visible()
    page.screenshot(path="playwright_tests/screenshots/addon_logs_page.png")
    expect(page.locator("ha-card h1")).to_have_text("Logs")
    expect(page.locator("ha-log-viewer")).to_be_visible()

def test_addon_ingress_page(logged_in_page: Page):
    page = logged_in_page
    page.goto(f"{HA_URL}/hassio/ingress/{OBSIDIAN_ADDON_SLUG}")
    page.screenshot(path="playwright_tests/screenshots/addon_ingress_page.png")
    # This might be tricky as it loads the Obsidian UI inside an iframe or similar.
    # We'll check for the presence of the iframe or a known element within the Obsidian UI.
    expect(page.locator("iframe")).to_be_visible()
    # Further checks would involve interacting with the Obsidian UI itself, which is more complex.
    # For now, just verifying the iframe is present is a good start.
