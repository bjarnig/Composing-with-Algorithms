<script setup lang="ts">
// Embeds an interactive audio tool from the class's public/ folder in a slide.
//
// The iframe is mounted only while its slide is the active one. That is the whole
// point: Slidev keeps neighbouring slides mounted, so a synth left running would
// keep sounding for the rest of the lecture. Unmounting tears down the iframe's
// AudioContext, so navigating away stops it.
import { computed } from 'vue'
import { useIsSlideActive } from '@slidev/client'

const props = withDefaults(defineProps<{
  src?: string        // page to embed, relative to the class's public/
  height?: string     // any CSS length
  compact?: boolean   // ask the tool for its slide-sized layout
  label?: string      // shown while the slide is not active
}>(), {
  src: '/demos/gendy/',
  height: '26rem',
  compact: true,
  label: 'audio demo',
})

const isActive = useIsSlideActive()
const url = computed(() =>
  props.compact
    ? props.src + (props.src.includes('?') ? '&' : '?') + 'compact=1'
    : props.src)
</script>

<template>
  <div class="audio-embed" :style="{ height }">
    <iframe
      v-if="isActive"
      :src="url"
      allow="autoplay"
      loading="lazy"
      title="interactive audio demo"
    />
    <div v-else class="audio-embed-idle">{{ label }}</div>
  </div>
</template>

<style scoped>
.audio-embed {
  width: 100%;
  margin: 0.6rem 0 0;
  border: 1px solid var(--cwa-rule);
  border-radius: 4px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.02);
}
.audio-embed iframe {
  width: 100%;
  height: 100%;
  border: 0;
  display: block;
}
.audio-embed-idle {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: var(--cwa-serif);
  font-style: italic;
  color: var(--cwa-muted);
  font-size: 0.9rem;
}
</style>
