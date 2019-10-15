<template>
  <section class="users">
    <h1>This is an user list page</h1>
    <router-link to="/">Back to home</router-link>
    <a-divider />
    <a-row :gutter="16">
      <a-col :xs="18">
        <a-list
          :grid="{ gutter: 16, xs: 1 }"
          :data-source="users"
          :loading="isLoading"
        >
          <a-list-item slot="renderItem" slot-scope="user">
            <p>
              {{ user.Username }} | {{ user.UserStatus }} | {{ getEmail(user.Attributes) }} | {{ userAdmin(user.groups) ? 'ADMIN' : 'USER' }} |
              <a-button v-if="isAdmin && !userAdmin(user.groups)" type="danger" @click="handleDelete(user.Username)">
                Delete
              </a-button>
            </p>
          </a-list-item>
        </a-list>
        <div v-if="nextToken" class="products__content--pagination">
          <a-button :loading="isLoading" @click="loadMore">
            Load more
          </a-button>
        </div>
      </a-col>
      <a-col :xs="6">
        <p><avatar :avatar="avatar" /></p>
        <h2>{{ email }}</h2>
        <h3>You are {{ isAdmin ? 'ADMIN' : 'USER' }}</h3>
      </a-col>
    </a-row>
  </section>
</template>
<script>
import gql from 'graphql-tag'
import { allUsers } from '@/api/graphql/queries'
import { deleteUser } from '@/api/graphql/mutation'
import { onUpdateUser } from '@/api/graphql/subscriptions'
import { getInfo } from '@/api/auth'

export default {
  components: {
    Avatar: () => import('@/components/tools/the-avatar.vue')
  },
  data () {
    return {
      users: [],
      nextToken: null,
      isLoading: false,
      userInfo: {
        username: '',
        attributes: {},
        groups: [],
        idToken: null
      }
    }
  },
  computed: {
    avatar() {
      return this.userInfo.attributes.picture || ''
    },
    email() {
      return this.userInfo.attributes.email
    },
    isAdmin() {
      return !!this.userInfo.groups.find(item => item.toLocaleLowerCase().includes('admin'))
    }
  },
  async created () {
    await this.getUserInfo()
    this.fetchAllUsers()

    this.$subscribeTo(
      this.$apollo.subscribe({ query: gql(onUpdateUser) }),
      (res) => {
        const { data: { onUpdateUser: user } } = res
        this.users = this.users.filter(item => item.Username !== user.Username)
      }
    )
  },
  mounted() {
    this.$bus.$on('change_users', user => {
        this.users = this.users.filter(item => item.Username !== user.Username)
    })
  },
  beforeDestroy() {
    this.$bus.$off('change_users')
  },
  methods: {
    async getUserInfo() {
      const userInfo =  await getInfo()
      if(!userInfo) this.$router.push({ path: '/' })
      else Object.assign(this.userInfo, userInfo)
    },
    async fetchAllUsers (params = {}) {
      try {
        this.isLoading = true
        const { data } = await this.$apollo.query({
          query: gql`${allUsers}`,
          variables: { ...params, limit: 5 }
        })
        const { allUsers: { items, nextToken } } = data
        this.users = this.users.concat(items)
        this.nextToken = nextToken

        this.isLoading = false
      } catch (error) {
        this.isLoading = false
        this.$message.error(error.message || 'Cannot load all users !!!')
      }
    },
    loadMore () {
      this.fetchAllUsers({ nextToken: this.nextToken })
    },
    getEmail (attribute) {
      const email = attribute.find(item => item.Name === 'email')
      return email ? email.Value : 'NOT FOUND'
    },
    userAdmin (groups) {
      return !!groups.find(item => item.GroupName === 'Admin')
    },
    async handleDelete (userName) {
      try {
        await this.$apollo.mutate({
          mutation: gql`${deleteUser}`,
          variables: { userName }
        })
        this.$message.success('Delete complete')
      } catch (error) {
        this.$message.error(error.message || 'Cannot delete users !!!')
      }
    }
  }
}
</script>

