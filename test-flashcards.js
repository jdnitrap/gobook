const { chromium } = require('playwright');

(async () => {
  console.log('=== FLASHCARD FUNCTIONALITY TEST ===\n');

  const browser = await chromium.launch({
    executablePath: '/opt/pw-browsers/chromium',
    headless: true
  });
  const page = await browser.newPage();

  try {
    // Navigate to app
    console.log('STEP 1: Loading application...');
    await page.goto('http://localhost:8000/index.html', { waitUntil: 'networkidle' });
    await page.waitForTimeout(1000);
    console.log('✓ App loaded');

    // Click Study Flashcards
    console.log('\nSTEP 2: Click "Study Flashcards" button...');
    await page.click('button:has-text("Study Flashcards")');
    await page.waitForTimeout(500);
    console.log('✓ Flashcard mode activated');

    // Verify Fluid Flow topic is available
    console.log('\nSTEP 3: Check for Fluid Flow (TH06B) topic...');
    const fluidFlowBtn = await page.locator('button:has-text("Fluid Flow")').count();
    if (fluidFlowBtn > 0) {
      console.log('✓ Fluid Flow (TH06B) topic found');

      // Click Fluid Flow topic
      console.log('\nSTEP 4: Select Fluid Flow (TH06B) topic...');
      await page.click('button:has-text("Fluid Flow")');
      await page.waitForTimeout(500);
      console.log('✓ Topic selected');

      // Click Start Flashcards button
      console.log('\nSTEP 5: Click "Start Flashcards" button...');
      const startBtn = await page.locator('button:has-text("Start Flashcards"), button:has-text("View Notes")').count();
      if (startBtn > 0) {
        await page.click('button:has-text("Start Flashcards"), button:has-text("View Notes")');
        await page.waitForTimeout(1000);
        console.log('✓ Flashcard screen loaded');

        // Check for card content
        console.log('\nSTEP 6: Verify card is displayed...');
        const cardContent = await page.locator('#cardContent').textContent();
        console.log(`Card Front: "${cardContent}"`);

        if (cardContent && cardContent.length > 0) {
          console.log('✓ Card front content displays correctly');

          // Flip the card
          console.log('\nSTEP 7: Flip the card...');
          const cardElement = await page.locator('.flashcard, #cardContent');
          await cardElement.click();
          await page.waitForTimeout(300);

          const flippedContent = await page.locator('#cardContent').textContent();
          console.log(`Card Back: "${flippedContent.substring(0, 80)}..."`);

          if (flippedContent && flippedContent !== cardContent) {
            console.log('✓ Card flips and shows back content');
          } else {
            console.log('⚠ Card may not be flipping properly');
          }

          // Check progress indicators
          console.log('\nSTEP 8: Verify progress indicators...');
          const cardNumber = await page.locator('#cardNumber').textContent();
          const cardTotal = await page.locator('#cardTotal').textContent();
          console.log(`Progress: Card ${cardNumber} of ${cardTotal}`);
          if (cardNumber === '1' && parseInt(cardTotal) > 0) {
            console.log('✓ Progress indicators working');
          }

          // Test Next Card button
          console.log('\nSTEP 9: Click "Next Card" button...');
          const nextBtn = await page.locator('button:has-text("Next Card")').count();
          if (nextBtn > 0) {
            await page.click('button:has-text("Next Card")');
            await page.waitForTimeout(500);

            const newCardNumber = await page.locator('#cardNumber').textContent();
            if (newCardNumber === '2') {
              console.log('✓ Navigation to next card works');

              const newCardContent = await page.locator('#cardContent').textContent();
              console.log(`Next Card: "${newCardContent}"`);
            } else {
              console.log('⚠ Could not navigate to next card');
            }
          }

          // Test return to home
          console.log('\nSTEP 10: Click return to home button...');
          const homeBtn = await page.locator('button:has-text("Return to Home")').count();
          if (homeBtn > 0) {
            await page.click('button:has-text("Return to Home")');
            await page.waitForTimeout(500);

            const examBtn = await page.locator('button:has-text("Exams")').count();
            if (examBtn > 0) {
              console.log('✓ Successfully returned to home');
            }
          }
        } else {
          console.log('✗ FAIL: No card content displayed');
        }
      } else {
        console.log('✗ FAIL: Start Flashcards/View Notes button not found');
      }
    } else {
      console.log('✗ FAIL: Fluid Flow (TH06B) topic not found in flashcard mode');
    }

  } catch (error) {
    console.error('\n✗ TEST ERROR:', error.message);
  } finally {
    await browser.close();
    console.log('\n=== TEST COMPLETE ===');
  }
})();
