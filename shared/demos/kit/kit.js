/* Shared plumbing for the course's Web Audio demos.
 *
 * Each demo supplies: an AudioWorklet processor in a <script type="text/js-worklet">
 * tag, a set of control ids, presets, and a draw function. The kit handles the parts
 * that are the same every time — worklet loading from a Blob, the play/stop
 * lifecycle, reading controls, readouts, presets, canvas DPR scaling, and the
 * file:// failure that otherwise looks like a dead button.
 *
 * Deliberately a plain global, no modules or build step: these pages are opened
 * directly and embedded in slides.
 */
window.Kit = (function () {

  const FRACTIONAL = /param$|scale$|^gain$|^prob|amt$|^mix$|^q$/;

  function compact() {
    if (new URLSearchParams(location.search).has('compact'))
      document.body.classList.add('compact');
  }

  function controls(ids) {
    const el = {};
    for (const id of ids) {
      const node = document.getElementById(id);
      if (!node) console.warn('[kit] no control with id', id);
      el[id] = node;
    }
    return el;
  }

  // current value of every control, numbers where possible
  function values(el) {
    const v = {};
    for (const id in el) {
      const e = el[id];
      if (!e) continue;
      if (e.type === 'checkbox') { v[id] = e.checked ? 1 : 0; continue; }
      const n = parseFloat(e.value);
      v[id] = Number.isNaN(n) ? e.value : n;
    }
    return v;
  }

  // write each control's value into its <output>, formatting fractions to 3dp
  function readouts(el, decide = FRACTIONAL) {
    for (const id in el) {
      const e = el[id];
      if (!e) continue;
      const out = e.parentElement && e.parentElement.querySelector('output');
      if (!out) continue;
      if (e.tagName === 'SELECT' || e.type === 'checkbox') { out.value = ''; continue; }
      const n = parseFloat(e.value);
      out.value = decide.test(id) ? n.toFixed(3) : n;
    }
  }

  function presets(map, apply) {
    document.querySelectorAll('button.preset').forEach(b =>
      b.addEventListener('click', () => {
        const p = map[b.dataset.p];
        if (p) apply(p);
      }));
  }

  // canvas sized for the device pixel ratio; returns the 2d context
  function fit(canvas) {
    const ctx = canvas.getContext('2d');
    const apply = () => {
      const r = canvas.getBoundingClientRect(), dpr = window.devicePixelRatio || 1;
      canvas.width = r.width * dpr;
      canvas.height = r.height * dpr;
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    };
    window.addEventListener('resize', apply);
    apply();
    return ctx;
  }

  function css(name) {
    return getComputedStyle(document.body).getPropertyValue(name).trim();
  }

  /* Load the worklet in the given script tag and build the graph.
     `prelude` is a list of extra script-tag ids prepended to the module source,
     for maths that has to be identical on the audio thread and in the drawing.
     Returns {ctx, node, analyser, scope}. */
  async function build({ scriptId = 'worklet', prelude = [], processor, channels = 2 }) {
    const ctx = new (window.AudioContext || window.webkitAudioContext)();
    const parts = [];
    for (const id of prelude) {
      const tag = document.getElementById(id);
      if (!tag) throw new Error(`[kit] no prelude script with id "${id}"`);
      parts.push(tag.textContent);
    }
    parts.push(document.getElementById(scriptId).textContent);
    const src = parts.join('\n;\n');
    const url = URL.createObjectURL(new Blob([src], { type: 'application/javascript' }));
    try {
      await ctx.audioWorklet.addModule(url);
    } finally {
      URL.revokeObjectURL(url);
    }
    const node = new AudioWorkletNode(ctx, processor,
      { numberOfInputs: 0, outputChannelCount: [channels] });
    const analyser = ctx.createAnalyser();
    analyser.fftSize = 2048;
    node.connect(analyser);
    analyser.connect(ctx.destination);
    return { ctx, node, analyser, scope: new Float32Array(analyser.fftSize) };
  }

  /* Wire a play/stop button. start() must return the object from build().
     Surfaces the file:// worklet failure instead of doing nothing. */
  function playButton(btn, start) {
    let state = null, playing = false;
    btn.addEventListener('click', async () => {
      if (!state) {
        try {
          state = await start();
        } catch (err) {
          state = null;
          const m = document.createElement('p');
          m.className = 'warn';
          m.style.color = 'var(--rose)';
          m.textContent = location.protocol === 'file:'
            ? 'Audio needs this page served over http, not opened as a file. '
            + 'Run "python3 -m http.server 8090" in the demos folder and open it via localhost.'
            : 'Could not start audio: ' + err.message;
          btn.parentElement.after(m);
          return;
        }
      }
      if (playing) {
        await state.ctx.suspend(); playing = false;
        btn.textContent = 'play'; btn.classList.remove('on');
      } else {
        await state.ctx.resume(); playing = true;
        btn.textContent = 'stop'; btn.classList.add('on');
      }
    });
    return () => state;
  }

  /* Oscilloscope trace. Only a few cycles are drawn: a whole 2048-sample buffer
     of a broadband signal reads as noise rather than as a waveform. */
  function drawScope(ctx2d, W, H, analyser, buf, { hz = 220, gain = 0.12, sampleRate = 48000 } = {}) {
    if (!analyser) return;
    analyser.getFloatTimeDomainData(buf);
    const mid = H / 2;
    const win = Math.max(128, Math.min(buf.length,
      Math.round(sampleRate / Math.max(20, hz) * 2)));
    const norm = mid * 0.92 / Math.max(0.02, gain);
    ctx2d.strokeStyle = 'rgba(154,164,181,.38)';
    ctx2d.lineWidth = 1;
    ctx2d.beginPath();
    for (let i = 0; i < win; i++) {
      const x = (i / (win - 1)) * W;
      const y = mid - buf[i] * norm;
      i ? ctx2d.lineTo(x, y) : ctx2d.moveTo(x, y);
    }
    ctx2d.stroke();
  }

  function axis(ctx2d, W, H) {
    const mid = H / 2;
    ctx2d.strokeStyle = 'rgba(255,255,255,.10)';
    ctx2d.lineWidth = 1;
    ctx2d.beginPath(); ctx2d.moveTo(0, mid); ctx2d.lineTo(W, mid); ctx2d.stroke();
  }

  return { compact, controls, values, readouts, presets, fit, css, build, playButton, drawScope, axis };
})();
