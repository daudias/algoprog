React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Switch,
  Redirect
} from 'react-router-dom'

import UserBadgePage from './pages/UserBadgePage'
import FullUserPage from './pages/FullUserPage'
import DashboardPage from './pages/DashboardPage'
import TablePage from './pages/TablePage'
import LevelPage from './pages/LevelPage'
import MaterialPage from './pages/MaterialPage'
import SolvedByWeekPage from './pages/SolvedByWeekPage'
import ContestPage from './pages/ContestPage'
import RootPage from './pages/RootPage'

import Login from './components/Login'
import Register from './components/Register'

class NoMatch extends React.Component
    render: () ->
        return <h2>404 Not found</h2>

export default [
    {
        path: '/userBadge/:id',
        key: "userBadge",
        component: UserBadgePage,
        loadData: UserBadgePage.loadData,
    },
    {
        path: '/user/:id',
        key: "user",
        component: FullUserPage,
        loadData: FullUserPage.loadData,
    },
    {
        path: '/table/:userList/:id',
        key: "table",
        component: TablePage
        loadData: TablePage.loadData,
    },
    {
        path: '/dashboard',
        key: "dashboard",
        component: DashboardPage,
        loadData: DashboardPage.loadData,
    },
    {
        path: '/solvedByWeek/:userList',
        key: "solvedByWeek",
        component: SolvedByWeekPage,
        loadData: SolvedByWeekPage.loadData,
    },
    {
        path: '/material/:id',
        key: "material",
        component: MaterialPage,
        loadData: MaterialPage.loadData,
    },
    {
        path: '/login',
        key: "login",
        component: Login,
    },
    {
        path: '/register',
        key: "register",
        component: Register,
    },
    {
        path: '/',
        key: "/",
        component: RootPage,
        loadData: RootPage.loadData,
    },
    {
        component: NoMatch,
        key: "nomatch"
    },
]
