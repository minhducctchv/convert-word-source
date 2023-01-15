<script setup>
import {computed, onMounted, ref} from "vue";
import {ElMessage} from 'element-plus'

defineProps({
  msg: {
    type: String,
    default: ''
  }
})

function getParamFromUrl(paramName = 'word') {
  return new URL(location.href).searchParams.get(paramName)
}

function convertWord(word) {
  const arrayCharacters = word.split('')
  const dashArr = arrayCharacters.map((s) => {
    return s === '-' ? s : '_'
  })
  const dashArrWithFirst = arrayCharacters.map((s, index) => {
    return index === 0 || s === '-' ? s : '_'
  })
  const dashArrWithFirstLast = arrayCharacters.map((s, index) => {
    return index === 0 || index === arrayCharacters.length - 1 || s === '-' ? s : '_'
  })
  return {
    arrayCharacters: arrayCharacters.sort(),
    dashArr: dashArr,
    dashArrWithFirst: dashArrWithFirst,
    dashArrWithFirstLast: dashArrWithFirstLast
  }
}

function convertMultiWord(text) {
  text = removeManySpace(text)
  if (!text) {
    showMess('Xin hãy nhập text', 'error')
    return []
  }
  const wordArr = text.split(' ')
  return wordArr.map(s => convertWord(s))
}

function removeManySpace(text) {
  if (!text) return null
  text = text.trim()
  if (!text) return null
  while (true) {
    if (text.includes('  ')) {
      text = text.replaceAll('  ', ' ')
    } else {
      break
    }
  }
  return text
}

function joinOutputArr(arr) {
  if (!arr || arr.length < 2) return null
  const customJoin = (s, regex = ' ') => {
    return Array.isArray(s) ? s.join(regex) : s
  }
  return arr.reduce((s, v) => {
    return {
      arrayCharacters: customJoin(s.arrayCharacters) + '\xa0\xa0\xa0' + customJoin(v.arrayCharacters),
      dashArr: customJoin(s.dashArr) + '\xa0\xa0\xa0' + customJoin(v.dashArr),
      dashArrWithFirst: `${customJoin(s.dashArrWithFirst)}\xa0\xa0\xa0${customJoin(v.dashArrWithFirst)}`,
      dashArrWithFirstLast: customJoin(s.dashArrWithFirstLast) + '\xa0\xa0\xa0' + customJoin(v.dashArrWithFirstLast)
    }
  })
}


const showMess = (mess, type = 'success') => {
  ElMessage({
    showClose: true,
    message: mess,
    type: type  // success, error, warning, ko co => [default]
  })
}

onMounted(() => {
  setTimeout(() => {
    inputText.value = removeManySpace(getParamFromUrl())
  })
})

const inputText = ref('')

const outputFinalArr = computed(() => {
  if (!removeManySpace(inputText.value)) return null
  return joinOutputArr(convertMultiWord((inputText.value)))
})

const outputArr = computed(() => {
  if (!removeManySpace(inputText.value)) return []
  return convertMultiWord((inputText.value))
})

const colors = [
  '#c1c4ef',
  '#d2efc1',
  '#efc1c1',
  '#d9c1ef'
]

</script>

<template>
  <div>
    <el-row :gutter="10">
      <el-col :xs="24" :sm="24" :md="8" :lg="12" :xl="12">
        <el-input
            type="text"
            v-model="inputText"
            clearable
            show-word-limit
            placeholder="Nhập từ vào đây"
            maxlength="100"/>
      </el-col>
      <el-col :xs="24" :sm="24" :md="8" :lg="12" :xl="12">
        <div>
          <div v-for="(item, index) in outputArr" :style="{backgroundColor: colors[index%4], borderRadius: '6px', padding: '10px', margin: '10px'}"
               :key="index">
            <div>{{ item.arrayCharacters.join(' ') }}</div>
            <div>{{ item.dashArr.join(' ') }}</div>
            <div>{{ item.dashArrWithFirst.join(' ') }}</div>
            <div>{{ item.dashArrWithFirstLast.join(' ') }}</div>
          </div>
          <div v-if="!!outputFinalArr" style="border: #6b84bb solid 1px; border-radius: 6px; padding: 10px; margin: 10px">
            <div>{{ outputFinalArr.arrayCharacters }}</div>
            <div>{{ outputFinalArr.dashArr }}</div>
            <div>{{ outputFinalArr.dashArrWithFirst }}</div>
            <div>{{ outputFinalArr.dashArrWithFirstLast }}</div>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped>

</style>