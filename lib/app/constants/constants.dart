const kDefaultUrl = 'https://github.com/foliageSea/flicker_free';

const kToggleVideoScript =
    "document.querySelector('video')?.paused? document.querySelector('video')?.play():document.querySelector('video')?.pause();";

const kFullScreenVideoScript =
    "document.querySelector('.bpx-player-ctrl-web-enter')?.click()";

const kForwardVideoScript = "document.querySelector('video').currentTime += 5";

const kBackwardVideoScript = "document.querySelector('video').currentTime -= 5";

const kPreviousVideoScript =
    "document.querySelector('.bpx-player-ctrl-web-prev')?.click()";

const kNextVideoScript =
    "document.querySelector('.bpx-player-ctrl-web-next')?.click()";
