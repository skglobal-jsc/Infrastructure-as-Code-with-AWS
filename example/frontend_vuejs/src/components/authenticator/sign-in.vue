<template>
  <div class="user-layout-login-wraper">
    <a-spin :spinning="loadding">
      <h3>
        <span>Sign In</span>
      </h3>
      <a-form
        id="formLogin"
        ref="formLogin"
        class="user-layout-login"
        :form="form"
      >
        <a-form-item>
          <a-input
            v-decorator="[
              'username',
              {rules: [{ required: true, message: 'Please enter a phone number or email address' }], validateTrigger: 'change'}
            ]"
            size="large"
            type="text"
            placeholder="Enter your username"
          >
            <a-icon slot="prefix" type="user" :style="{ color: 'rgba(0,0,0,.25)' }" />
          </a-input>
        </a-form-item>

        <a-form-item>
          <a-input
            v-decorator="[
              'password',
              {rules: [{ required: true, message: 'Please enter your password' }], validateTrigger: 'blur'}
            ]"
            size="large"
            type="password"
            autocomplete="false"
            placeholder="Enter your password"
          >
            <a-icon slot="prefix" type="lock" :style="{ color: 'rgba(0,0,0,.25)' }" />
          </a-input>
        </a-form-item>

        <a-form-item>
          <!-- <a-checkbox v-decorator="['rememberMe']">Remember</a-checkbox> -->
          <span style="float: left;">
            Forget your password?
            <a class="forge-password" @click="forgot">Reset password</a>
          </span>
        </a-form-item>

        <a-form-item style="margin-top:24px">
          <a-button
            size="large"
            type="primary"
            html-type="submit"
            class="login-button"
            :loading="state.loginBtn"
            :disabled="state.loginBtn"
            @click.stop.prevent="handleSubmit"
          >
            Sign In
          </a-button>
        </a-form-item>

        <div class="user-login-other">
          <span>Login with</span>
          <a @click.stop.prevent="signIn('Facebook')">
            <a-icon class="item-icon" type="facebook" />
          </a>
          <a @click.stop.prevent="signIn('Google')">
            <a-icon class="item-icon" type="google-plus" />
          </a>
          <a v-if="options.isSignUpDisplayed" class="register" @click="signUp">Register</a>
        </div>
      </a-form>
    </a-spin>
  </div>
</template>

<script>
/* eslint-disable no-unused-vars */
import Auth from '@aws-amplify/auth'

export default {
  props: {
    signInConfig: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      loadding: false,
      loginBtn: false,
      form: this.$form.createForm(this),
      state: {
        loginBtn: false
      }
    }
  },
  computed: {
    options() {
      const defaults = {
        username: '',
        isSignUpDisplayed: true
      }
      return Object.assign(defaults, this.signInConfig || {})
    }
  },
  methods: {
    handleSubmit() {
      const {
        form: { validateFields },
        state
      } = this

      state.loginBtn = true

      const validateFieldsKey = ['username', 'password']
      validateFields(validateFieldsKey, { force: true }, (err, values) => {
        if (!err) {
          const loginParams = { ...values }
          Auth.signIn(loginParams.username, loginParams.password)
            .then((data) => {
              if (data.challengeName === 'SMS_MFA' || data.challengeName === 'SOFTWARE_TOKEN_MFA') {
                this.$bus.$emit('localUser', data)
                return this.$bus.$emit('authState', 'confirmSignIn')
              } else if (data.challengeName === 'NEW_PASSWORD_REQUIRED') {
                this.$bus.$emit('localUser', data)
                return this.$bus.$emit('authState', 'requireNewPassword')
              } else if (data.challengeName === 'MFA_SETUP') {
                this.$bus.$emit('localUser', data)
                return this.$bus.$emit('authState', 'setMfa')
              } else {
                return this.$bus.$emit('authState', 'signedIn')
              }
            })
            .catch((e) => {
              if (e.code && e.code === 'UserNotConfirmedException') {
                this.$bus.$emit('localUser', { username: this.options.username })
                this.$bus.$emit('authState', 'confirmSignUp')
              } else {
                this.setError(e)
              }
            })
            .finally(() => {
              state.loginBtn = false
            })
        } else {
          setTimeout(() => {
            state.loginBtn = false
          }, 600)
        }
      })
    },
    setError(err) {
      this.$notification.error({
        message: 'Error',
        description: err.message || 'Request error, please try again later',
        duration: 4
      })
    },
    forgot() {
      this.$bus.$emit('authState', 'forgotPassword')
    },
    signUp() {
      this.$bus.$emit('authState', 'signUp')
    },
    signIn(provider = 'Facebook') {
      this.loadding = true
      Auth.federatedSignIn({ provider: provider })
    }
  }
}
</script>

<style lang="scss" scoped>
.user-layout-login-wraper {
  & > h3 {
    font-size: 16px;
    margin-bottom: 20px;
  }
}
.user-layout-login {
  label {
    font-size: 14px;
  }

  .getCaptcha {
    display: block;
    width: 100%;
    height: 40px;
  }

  .forge-password {
    font-size: 14px;
  }

  button.login-button {
    padding: 0 15px;
    font-size: 16px;
    height: 40px;
    width: 100%;
  }

  .user-login-other {
    text-align: left;
    margin-top: 24px;
    line-height: 22px;

    .item-icon {
      font-size: 24px;
      color: rgba(0, 0, 0, 0.2);
      margin-left: 16px;
      vertical-align: middle;
      cursor: pointer;
      transition: color 0.3s;

      &:hover {
        color: #1890ff;
      }
    }

    .register {
      float: right;
    }
  }
}
</style>
