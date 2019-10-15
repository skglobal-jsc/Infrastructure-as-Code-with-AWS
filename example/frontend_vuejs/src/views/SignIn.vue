<template>
  <a-modal v-model="visible" centered :mask-closable="closable" :closable="closable" :footer="null">
    <a-spin :spinning="loadding">
      <sign-in />
    </a-spin>
  </a-modal>
</template>

<script>
import { timer } from 'rxjs'
import { getInfo } from '@/api/auth'
import SignIn from '@/components/authenticator/sign-in.vue'

export default {
  components: {
    SignIn // () => import('@/components/authenticator/sign-in.vue')
  },
  data () {
    return {
      visible: true,
      closable: false,
      loadding: true
    }
  },
  mounted () {
    this.$subscribeTo(timer(2000), () => {
      getInfo().then((user) => {
        if (user) {
          this.visible = false
          this.$router.push({ path: '/' })
        } else {
          this.closable = true
          this.loadding = false
          this.$router.go(0)
        }
      })
    })
  },
  beforeDestroy () {
    this.$router.go(0)
  }
}
</script>
