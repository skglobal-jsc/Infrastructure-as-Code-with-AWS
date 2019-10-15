<template>
  <div id="app">
    <h1>SKG - Sample SPA using AWS Cognito and AWS App Sync</h1>
    <div class="nav">
      <a-button v-if="!isLogin" @click="handleLogin">Login</a-button>
      <a-button v-else @click="handleLogout">Logout</a-button>
    </div>
    <div class="nav">
      <span v-if="!isLogin">Please press a login button now !!!</span>
      <div v-else>
        <p>Welcome {{ userInfo.attributes.email }}</p>
        <router-link to="/users">Go to user list page</router-link>
      </div>
    </div>
    <a-modal
      v-model="showLoginDialog"
      centered
      :mask-closable="true"
      :closable="true"
      :footer="null"
    >
      <authenticator />
    </a-modal>
    <router-view/>
  </div>
</template>
<script>
import { logout, getInfo } from '@/api/auth'

export default {
  components: {
    Authenticator: () => import('@/components/authenticator/authenticator.vue')
  },
  data () {
    return {
      showLoginDialog: false,
      userInfo: {
        username: '',
        attributes: {},
        groups: [],
        idToken: null
      }
    }
  },
  computed: {
    isLogin() {
      return this.userInfo.idToken
    }
  },
  created() {
    this.getUserInfo()
  },
  mounted () {
    this.$bus.$on('authState', (info) => {
      if (info === 'signedIn') {
        this.showLoginDialog = false
        this.$message.success('You are login success')
        this.getUserInfo()
      }
    })

    this.$bus.$on('showLoginDialog', (showLoginDialog) => {
      this.showLoginDialog = showLoginDialog
    })
  },
  methods: {
    async getUserInfo() {
      const userInfo =  await getInfo()
      Object.assign(this.userInfo, userInfo)
    },
    handleLogin () {
      this.$bus.$emit('showLoginDialog', true)
    },
    handleLogout() {
      logout()
      .then(() => {
        const userInfo = {
          username: '',
          attributes: {},
          groups: [],
          idToken: null
        }
        Object.assign(this.userInfo, userInfo)
        this.$router.push({ path: '/' })
      })
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
.nav {
  padding: 15px;
}
</style>
