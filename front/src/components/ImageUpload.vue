<template>
  <div class="img-upload">
    <!-- Preview -->
    <div v-if="modelValue" class="img-upload__preview">
      <img :src="modelValue" alt="Cover" />
      <button type="button" class="img-upload__remove" @click="remove" title="Remove image">×</button>
    </div>
    <!-- Drop zone -->
    <label v-else class="img-upload__area" :class="{ 'is-dragging': dragging }"
      @dragover.prevent="dragging=true" @dragleave="dragging=false"
      @drop.prevent="onDrop">
      <input ref="inputRef" type="file" accept="image/*" style="display:none" @change="onFileChange" />
      <div class="img-upload__placeholder">
        <span class="img-upload__icon">🖼</span>
        <span v-if="uploading" class="img-upload__hint">Uploading...</span>
        <template v-else>
          <span class="img-upload__hint">Click or drag to upload</span>
          <span class="img-upload__sub">jpg / png / gif / webp, max 10MB</span>
        </template>
      </div>
    </label>
    <p v-if="error" class="img-upload__error">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { uploadImage } from '../api/index.js'

const props = defineProps({ modelValue: String })
const emit  = defineEmits(['update:modelValue'])

const dragging  = ref(false)
const uploading = ref(false)
const error     = ref('')
const inputRef  = ref(null)

async function handleFile(file) {
  if (!file) return
  if (file.size > 10 * 1024 * 1024) { error.value = 'File must be 10MB or smaller'; return }
  uploading.value = true; error.value = ''
  try {
    const res = await uploadImage(file)
    if (res.code === 200) emit('update:modelValue', res.data)
    else error.value = res.msg || 'Upload failed'
  } catch {
    error.value = 'Upload failed. Check your network.'
  } finally {
    uploading.value = false
  }
}

function onFileChange(e) { handleFile(e.target.files[0]) }
function onDrop(e) { dragging.value = false; handleFile(e.dataTransfer.files[0]) }
function remove() { emit('update:modelValue', ''); if (inputRef.value) inputRef.value.value = '' }
</script>

<style scoped>
.img-upload { width: 100%; }

.img-upload__preview {
  position: relative; display: inline-block;
  border-radius: 8px; overflow: hidden;
  border: 1px solid var(--border);
}
.img-upload__preview img {
  display: block; max-width: 100%; max-height: 160px;
  object-fit: cover; width: 100%;
}
.img-upload__remove {
  position: absolute; top: 6px; right: 6px;
  background: rgba(0,0,0,0.55); color: #fff;
  border: none; border-radius: 50%;
  width: 24px; height: 24px; font-size: 14px;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
}
.img-upload__remove:hover { background: var(--danger); }

.img-upload__area {
  display: flex; align-items: center; justify-content: center;
  width: 100%; min-height: 110px;
  border: 2px dashed var(--border); border-radius: 8px;
  cursor: pointer; transition: all 0.2s; background: #fafafa;
}
.img-upload__area:hover, .img-upload__area.is-dragging {
  border-color: var(--primary); background: #f0eeff;
}

.img-upload__placeholder {
  display: flex; flex-direction: column; align-items: center; gap: 4px;
  pointer-events: none;
}
.img-upload__icon  { font-size: 28px; }
.img-upload__hint  { font-size: 13px; color: #555; font-weight: 500; }
.img-upload__sub   { font-size: 11px; color: #aaa; }
.img-upload__error { margin-top: 6px; font-size: 12px; color: var(--danger); }
</style>
