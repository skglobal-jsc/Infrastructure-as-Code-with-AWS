import Vue from 'vue'
import App from './App'
import router from './router'

// antd-ui
import Antd from 'ant-design-vue'
import 'ant-design-vue/dist/antd.min.css'
Vue.use(Antd)

// vue rx
import VueRx from 'vue-rx'
Vue.use(VueRx)

// aws cognito config
import Auth from '@aws-amplify/auth'
import Storage from '@aws-amplify/storage'
import Amplify from '@aws-amplify/core'
import awsmobile from '@/config/aws-exports'

Amplify.configure(awsmobile)
Vue.use({ Auth, Storage })

// aws app sync
import apolloProvider from '@/plugins/app-sync'

Vue.prototype.$bus = new Vue()
Vue.config.productionTip = false
new Vue({
  router,
  apolloProvider,
  render: h => h(App)
}).$mount('#app')
