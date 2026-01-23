import express from "express"
import 'dotenv/config'
import userRouter from './routes/user.route.js'
import contestRouter from './routes/contest.route.js'
import { authMiddleware } from "./middleware/auth.middleware.js"
import dsaRouter from './routes/dsa.route.js'

const app = express()
const PORT = process.env.PORT

app.use(express.json())

app.use('/api/auth',userRouter)
app.use('/api/contests',authMiddleware,contestRouter)
app.use('/api/problems',authMiddleware,dsaRouter)


app.listen(PORT,()=>{
    console.log(`App is running on http://localhost:${PORT}`)
})