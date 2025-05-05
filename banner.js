Reveal.addEventListener('slidechanged', function(event) {
  // Remove any existing banner
  let existingBanner = document.querySelector('.bottom-banner');
  if (existingBanner) {
    existingBanner.remove();
  }

  // Create the banner element
  let banner = document.createElement('div');
  banner.classList.add('bottom-banner');

  // Append the banner to the current slide
  event.currentSlide.appendChild(banner);
});