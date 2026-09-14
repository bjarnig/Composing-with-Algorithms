<script setup lang="ts">
// A listening example: the title and a play control, and deliberately nothing else.
// No elapsed time and no progress bar, because knowing how long a piece runs changes
// how it is listened to.
//
// Two things matter for class use. The <audio> element is given preload="none" and no
// src until the first play, so passing through the slide costs nothing; the browser
// then fetches by range and starts within a second whatever the file size. And the
// element is torn down when the slide stops being the active one, because Slidev keeps
// neighbouring slides mounted and a piece left running would follow you through the
// rest of the lecture.
import { computed, ref, watch, onBeforeUnmount } from 'vue'
import { useIsSlideActive } from '@slidev/client'

const props = withDefaults(defineProps<{
  file?: string       // name under the bucket's audio/ prefix, or a full URL
  base?: string
  title?: string      // falls back to the slot
  label?: string      // the small marker above the title; '' removes it
}>(), {
  file: '',
  base: 'https://slides.bjarni-gunnarsson.net/audio/',
  title: '',
  label: 'listening',
})

const isActive = useIsSlideActive()
const el = ref<HTMLAudioElement | null>(null)
const started = ref(false)     // has the user asked for it at least once
const playing = ref(false)
const waiting = ref(false)
const failed = ref('')

const src = computed(() =>
  /^https?:\/\//.test(props.file) ? props.file : props.base + props.file)

async function toggle(ev: MouseEvent) {
  // Slidev binds space and the arrows; a focused button would swallow them.
  ;(ev.currentTarget as HTMLElement)?.blur()
  started.value = true
  await new Promise(r => setTimeout(r, 0))   // let the <audio> mount with its src
  const a = el.value
  if (!a) return
  if (a.paused) {
    waiting.value = true
    failed.value = ''
    try { await a.play() } catch (e: any) { failed.value = e?.message || 'could not play' }
    waiting.value = false
  } else {
    a.pause()
  }
}

function stop() {
  const a = el.value
  if (a) { a.pause(); a.currentTime = 0 }
  playing.value = false
  started.value = false        // unmounts the element, dropping the connection
}

// leaving the slide stops the piece
watch(isActive, v => { if (!v) stop() })
onBeforeUnmount(stop)
</script>

<template>
  <div class="listen">
    <div v-if="label" class="listen-label">{{ label }}</div>
    <div class="listen-title"><slot>{{ title }}</slot></div>

    <audio
      v-if="started"
      ref="el"
      :src="src"
      preload="none"
      @play="playing = true"
      @pause="playing = false"
      @waiting="waiting = true"
      @playing="waiting = false"
      @ended="playing = false"
      @error="failed = 'could not load ' + src"
    />

    <div class="listen-bar">
      <button class="listen-btn" :aria-label="playing ? 'pause' : 'play'" @click="toggle">
        <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true">
          <path v-if="!playing" d="M7 4 L19 12 L7 20 Z" fill="currentColor" />
          <g v-else fill="currentColor"><rect x="6" y="4" width="4" height="16" /><rect x="14" y="4" width="4" height="16" /></g>
        </svg>
      </button>
    </div>

    <div v-if="failed" class="listen-note listen-failed">{{ failed }}</div>
    <div v-else-if="waiting" class="listen-note">loading</div>
  </div>
</template>

<style scoped>
/* A percentage width would resolve against the shrink-wrapped box of a centre
   layout. rem also tracks the scaling Slidev applies to the whole slide. */
.listen { width: 30rem; max-width: 100%; margin: 0 auto; }
/* Deliberately quieter than .slidev-layout.divider p, which is 2rem and shouts.
   A divider names a section; this slide is one piece being played, so the marker
   carries the function and the title only has to be legible from the back. */
.listen-label {
  font-family: var(--cwa-sans);
  font-size: 0.72rem;
  letter-spacing: 0.2em;
  text-transform: lowercase;
  text-align: center;
  color: var(--cwa-muted);
  margin-bottom: 0.9rem;
}
.listen-title {
  font-family: var(--cwa-sans);
  font-weight: 600;
  letter-spacing: -0.005em;
  font-size: 1.25rem;
  line-height: 1.35;
  text-align: center;
  color: #fff;
  margin-bottom: 1.6rem;
}
.slidev-layout.light .listen-title { color: #111; }
.slidev-layout.light .listen-label { color: #666; }
.listen-bar { display: flex; justify-content: center; }
.listen-btn {
  width: 2rem; height: 2rem;
  display: flex; align-items: center; justify-content: center;
  border: 1px solid var(--cwa-rule);
  border-radius: 50%;
  background: transparent;
  color: var(--cwa-fg);
  cursor: pointer;
  transition: border-color 0.15s, color 0.15s;
}
.listen-btn:hover { border-color: var(--cwa-accent); color: var(--cwa-accent); }
.slidev-layout.light .listen-btn { color: #111; }
.listen-note {
  margin-top: 0.9rem;
  text-align: center;
  font-family: var(--cwa-sans);
  font-size: 0.72rem;
  letter-spacing: 0.12em;
  color: var(--cwa-muted);
}
.listen-failed { color: var(--cwa-rose); letter-spacing: 0; }
</style>
