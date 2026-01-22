import express from "express"
import 'dotenv/config'
import userRouter from './routes/user.route.js'

const app = express()
const PORT = process.env.PORT

app.use(express.json())

app.use('/api/auth',userRouter)


app.listen(PORT,()=>{
    console.log(`App is running on http://localhost:${PORT}`)
})