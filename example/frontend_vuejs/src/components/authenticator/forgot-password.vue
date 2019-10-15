<template>
  <div class="main user-layout-reset">
    <h3>Reset your password</h3>
    <a-form id="formReset" ref="formReset" autocomplete="off" :form="form">
      <a-form-item>
        <a-input
          v-decorator="['username', {rules: [{ required: true, message: 'Please input username' }], validateTrigger: ['change', 'blur']}]"
          size="large"
          type="text"
          autocomplete="new-username"
          placeholder="Email or Phone number"
        />
      </a-form-item>
      <a-row v-if="sent" :gutter="16">
        <a-col class="gutter-row" :span="16">
          <a-form-item>
            <a-input
              v-decorator="['code', {rules: [{ required: true, message: 'Please input verification code' }], validateTrigger: 'blur'}]"
              size="large"
              type="text"
              placeholder="Reset code"
            >
              <a-icon slot="prefix" type="mail" :style="{ color: 'rgba(0,0,0,.25)' }" />
            </a-input>
          </a-form-item>
        </a-col>
        <a-col class="gutter-row" :span="8">
          <a-button
            class="getCaptcha"
            size="large"
            :disabled="state.smsSendBtn"
            @click.stop.prevent="resend"
            v-text="!state.smsSendBtn && 'Resend' ||(state.time+' s')"
          />
        </a-col>
      </a-row>

      <a-popover v-if="sent" v-model="state.passwordLevelChecked" placement="rightTop" trigger="click">
        <template slot="content">
          <div :style="{ width: '240px' }">
            <div :class="['user-register', passwordLevelClass]">
              Password strength:
              <span>{{ passwordLevelName }}</span>
            </div>
            <a-progress
              :percent="state.percent"
              :show-info="false"
              :stroke-color=" passwordLevelColor "
            />
            <div style="margin-top: 10px;">
              <span>Please enter at least 8 characters. Please do not use passwords that are easy to guess.</span>
            </div>
          </div>
        </template>
        <a-form-item>
          <a-input
            v-decorator="['password', {rules: [{ required: true, message: 'At least 8-digit password, case sensitive.'}, { validator: handlePasswordLevel }], validateTrigger: ['change', 'blur']}]"
            size="large"
            type="password"
            autocomplete="new-password"
            placeholder="New Password"
            @click="handlePasswordInputClick"
          />
        </a-form-item>
      </a-popover>
      <a-form-item v-if="!sent">
        <a-button
          size="large"
          type="primary"
          html-type="submit"
          class="register-button"
          :loading="state.smsSendBtn"
          :disabled="state.smsSendBtn"
          @click.stop.prevent="resend"
        >
          Send code
        </a-button>
        <a class="login" @click="signIn">Sign In</a>
      </a-form-item>
      <a-form-item v-if="sent">
        <a-button
          size="large"
          type="primary"
          html-type="submit"
          class="register-button"
          :loading="registerBtn"
          :disabled="registerBtn"
          @click.stop.prevent="handleSubmit"
        >
          Submit
        </a-button>
      </a-form-item>
    </a-form>
  </div>
</template>

<script>
import Auth from '@aws-amplify/auth'

const levelNames = {
  0: 'Very weak',
  1: 'Weak',
  2: 'Good',
  3: 'Great'
}
const levelClass = {
  0: 'error',
  1: 'error',
  2: 'warning',
  3: 'success'
}
const levelColor = {
  0: '#ff0000',
  1: '#ff0000',
  2: '#ff7e05',
  3: '#52c41a'
}
export default {
  name: 'ForgotPassword',
  props: {
    forgotPasswordConfig: {
      type: Object,
      default: () => {}
    }
  },
  data () {
    return {
      form: this.$form.createForm(this),
      state: {
        passwordLevel: 0,
        passwordLevelChecked: false,
        percent: 10,
        progressColor: '#FF0000',
        time: 60,
        smsSendBtn: false
      },
      registerBtn: false,
      sent: false
    }
  },
  computed: {
    options () {
      const defaults = {
      }
      return Object.assign(defaults, this.forgotPasswordConfig || {})
    },
    passwordLevelClass () {
      return levelClass[this.state.passwordLevel]
    },
    passwordLevelName () {
      return levelNames[this.state.passwordLevel]
    },
    passwordLevelColor () {
      return levelColor[this.state.passwordLevel]
    }
  },
  methods: {
    handlePasswordLevel (rule, value, callback) {
      let level = 0

      // Determine if there are any numbers in this string
      if (/[0-9]/.test(value)) {
        level++
      }
      // Determine if there are any letters in the string
      if (/[a-zA-Z]/.test(value)) {
        level++
      }
      // Determine if there are any special symbols in the string
      if (/[^0-9a-zA-Z_]/.test(value)) {
        level++
      }
      this.state.passwordLevel = level
      this.state.percent = level * 30
      if (level >= 2) {
        if (level >= 3) {
          this.state.percent = 100
        }
        callback()
      } else {
        if (level === 0) {
          this.state.percent = 10
        }
        callback(new Error('Insufficient password strength'))
      }
    },

    handlePasswordInputClick () {
      if (!this.isMobile()) {
        this.state.passwordLevelChecked = true
        return
      }
      this.state.passwordLevelChecked = false
    },

    handleSubmit () {
      const {
        form: { validateFields }
      } = this
      validateFields({ force: true }, (err, values) => {
        if (!err) {
          const { username, code, password } = values
          Auth.forgotPasswordSubmit(username, code, password)
            .then(() => {
              this.$bus.$emit('authState', 'signIn')
            })
            .catch(e => this.setError(e))
        }
      })
    },

    setError (err) {
      this.$notification.error({
        message: 'Error',
        description: err.message || 'Request error, please try again later',
        duration: 4
      })
      this.registerBtn = false
    },
    resend (e) {
      e.preventDefault()
      const {
        form: { validateFields },
        state,
        $message,
        $notification
      } = this

      validateFields(['username'], { force: true }, (err, values) => {
        if (!err) {
          state.smsSendBtn = true

          const interval = window.setInterval(() => {
            if (state.time-- <= 0) {
              state.time = 60
              state.smsSendBtn = false
              window.clearInterval(interval)
            }
          }, 1000)

          const hide = $message.loading('Reset code is being sent..', 0)
          Auth.forgotPassword(values.username)
            .then(() => {
              this.sent = true
              $notification.success({
                message: 'Info',
                description: 'The reset code is successfully obtained. Please check your e-mail',
                duration: 8
              })
            })
            .catch((err) => {
              clearInterval(interval)
              state.time = 60
              state.smsSendBtn = false
              this.setError(err)
            })
            .finally(() => {
              setTimeout(hide, 1)
            })
        }
      })
    },
    signIn () {
      this.$bus.$emit('authState', 'signIn')
    }
  }
}
</script>
<style lang="scss">
.user-register {
  &.error {
    color: #ff0000;
  }

  &.warning {
    color: #ff7e05;
  }

  &.success {
    color: #52c41a;
  }
}

.user-layout-reset {
  .ant-input-group-addon:first-child {
    background-color: #fff;
  }
}
</style>
<style lang="scss" scoped>
.user-layout-reset {
  & > h3 {
    font-size: 16px;
    margin-bottom: 20px;
  }

  .getCaptcha {
    display: block;
    width: 100%;
    height: 40px;
  }

  .register-button {
    width: 50%;
    float: right;
  }

  .login {
    // float: right;
    line-height: 40px;
  }
}
</style>
