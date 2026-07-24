const { chromium } = require('playwright');

(async () => {
  console.log('=== STUDY NOTES IMAGE TEST ===\n');

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

    // Click Study Notes
    console.log('\nSTEP 2: Click "Study Notes" button...');
    await page.click('button:has-text("Study Notes")');
    await page.waitForTimeout(500);
    console.log('✓ Study Notes mode activated');

    // Click Fluid Flow topic
    console.log('\nSTEP 3: Select Fluid Flow (TH06B) topic...');
    await page.click('button:has-text("Fluid Flow")');
    await page.waitForTimeout(500);
    console.log('✓ Topic selected');

    // View notes
    console.log('\nSTEP 4: Click "View Notes" button...');
    await page.click('button:has-text("View Notes")');
    await page.waitForTimeout(1000);
    console.log('✓ Notes view loaded');

    // Check for images
    console.log('\nSTEP 5: Verify images are displayed...');
    
    // Count images in the page
    const images = await page.locator('img.note-diagram').count();
    console.log(`Images found: ${images}`);
    
    if (images >= 4) {
      console.log('✓ All expected images (4+) are present');
      
      // Check specific images
      const imageUrls = await page.locator('img.note-diagram').allTextContents();
      const imageSrcs = await Promise.all(
        (await page.locator('img.note-diagram').all()).map(img => img.getAttribute('src'))
      );
      
      console.log('\nImage sources:');
      imageSrcs.forEach((src, idx) => {
        console.log(`  ${idx + 1}. ${src}`);
      });
      
      // Check for viscosity image specifically
      const hasViscosity = imageSrcs.some(src => src.includes('image2.png'));
      if (hasViscosity) {
        console.log('\n✓ Viscosity diagram (image2.png) found');
      } else {
        console.log('\n⚠ Viscosity diagram (image2.png) NOT found');
      }
      
      // Check for laminar flow images
      const hasLaminar = imageSrcs.filter(src => src.includes('image13') || src.includes('image14')).length;
      if (hasLaminar > 0) {
        console.log(`✓ Laminar flow diagrams found (${hasLaminar})`);
      } else {
        console.log('⚠ Laminar flow diagrams NOT found');
      }
      
    } else {
      console.log(`⚠ Only ${images} images found (expected 4+)`);
    }

  } catch (error) {
    console.error('\n✗ TEST ERROR:', error.message);
  } finally {
    await browser.close();
    console.log('\n=== TEST COMPLETE ===');
  }
})();
