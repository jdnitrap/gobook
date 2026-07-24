const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    executablePath: '/opt/pw-browsers/chromium',
    headless: true
  });
  const page = await browser.newPage();

  try {
    await page.goto('http://localhost:8000/index.html', { waitUntil: 'networkidle' });
    await page.waitForTimeout(1000);

    // Click Study Flashcards
    await page.click('button:has-text("Study Flashcards")');
    await page.waitForTimeout(500);

    // Click Fluid Flow topic
    await page.click('button:has-text("Fluid Flow")');
    await page.waitForTimeout(500);

    // Get all buttons on the page
    const buttons = await page.locator('button').allTextContents();
    console.log('Available buttons after selecting Fluid Flow:');
    buttons.forEach(btn => console.log(`  - ${btn}`));

    // Get the page HTML to see the structure
    const html = await page.content();
    const startIdx = html.indexOf('selectedNotesSubjectName');
    if (startIdx > 0) {
      console.log('\nPage structure around flashcard start area:');
      console.log(html.substring(startIdx, startIdx + 500));
    }

    // Check for any text that might indicate a button
    const allText = await page.textContent('body');
    if (allText.includes('Start')) {
      console.log('\n"Start" text found on page');
    }

  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await browser.close();
  }
})();
