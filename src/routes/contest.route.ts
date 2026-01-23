import express, { Request, Response } from 'express'
import { prisma } from '../lib/prisma.js'
import { createContestSchema } from '../schema/contestSchema.js'
import { ZodError } from 'zod'
import { errorResponse, successResponse } from '../lib/response.js'
import { mcqSchema, selectedOptionSchema } from '../schema/mcqSchema.js'
const router = express.Router()

router.post('/',async(req:Request, res:Response)=>{
    try {
        
    const userId = (req as any).user.id
    const user = await prisma.user.findFirst({
        where:{
            id:userId
        }
    })
    if(user?.role != 'creator'){
        return res.status(403).json(errorResponse('FORBIDDEN'))
    }


    const validatedData = createContestSchema.safeParse(req.body)
    if(!validatedData.success){
        return res.status(400).json(errorResponse('INVALID_REQUEST'))
    }
    const {title,description,startTime,endTime} = validatedData.data

    const contest = await prisma.contest.create({
        data:{
            title,
            description,
            startTime,
            endTime,
            creatorId:user.id 
        }
    })

    res.status(201).json(successResponse({
            "id": contest.id,
            "title": contest.title,
            "description": contest.description,
            "creatorId": contest.creatorId,
            "startTime": contest.startTime,
            "endTime": contest.endTime
        }))

    
    } catch (error) {
     console.error('Error in creating contest\n',error)
     res.status(500).json({
        message:'Internal server error'
     })
    }
    
})

router.get('/:contestId',async(req:Request,res:Response)=>{
    try {
        const contestId =Number(req.params.contestId)

        if(isNaN(contestId)){
            return res.status(404).json(errorResponse('CONTEST_NOT_FOUND'))
        }
        
        const contest = await prisma.contest.findFirst({
            where:{
                id:contestId
            },
            select:{
                id:true,
                title:true,
                description:true,
                startTime:true,
                endTime:true,
                creatorId:true,
                mcqs:{
                    select:{
                        id:true,
                        questionText:true,
                        options:true,
                        points:true
                    }
                },
                dsaProblems:{
                    select:{
                        id:true,
                        title:true,
                        description:true,
                        tags:true,
                        points:true,
                        timeLimit:true,
                        memoryLimit:true
                    }
                }
            }
        })
        if(!contest){
            return res.status(404).json(errorResponse('CONTEST_NOT_FOUND'))
        }
        
        res.status(200).json({
            success:true,
            data:contest,
            error:null
        })
        
    } catch (error) {
        console.error("Error in get contest route\n",error)
        res.status(500).json({
            message:'Internal Server Error'
        })
    }
})

router.post('/:contestId/mcq',async(req:Request,res:Response)=>{

    try {
        
   
    const contestId = Number(req.params.contestId)

    const contest = await prisma.contest.findFirst({
        where:{
            id:contestId
        }
    })

    if(!contest){
        return res.status(404).json({
            "success": false,
            "data": null,
            "error": "CONTEST_NOT_FOUND"
        })
    }

    const user = await prisma.user.findFirst({
        where:{
            id:(req as any).user.id
        }
    })

    if(user?.role !== 'creator'){
        return res.status(403).json({
            "success": false,
            "data": null,
            "error": "FORBIDDEN"
        })
    }
    
    const validatedData = mcqSchema.safeParse(req.body)
    if(!validatedData.success){
        return res.status(400).json({
            "success": false,
            "data": null,
            "error": "INVALID_REQUEST"
        })
    }

    const {questionText,options,correctOptionIndex,points} = validatedData.data

    const mcq = await prisma.mcq_question.create({
        data:{
            correctOptionIndex,
            options,
            questionText,
            points,
            contestId

        }
    })
    
    res.status(201).json({
        "success": true,
        "data": {
            "id": mcq.id,
            contestId
        },
        "error": null
    })

 } catch (error) {
       console.error('Error in creating mcq\n',error)
       res.status(500).json({
        message:'Internal server error'
       })
    }
    
    
})

router.post('/:contestId/mcq/:questionId/submit',async(req:Request,res:Response)=>{
    try {
        
    const contestId = Number(req.params.contestId)
    const questionId = Number(req.params.questionId)

    const userId = (req as any).user.id
    const user = await prisma.user.findFirst({
        where:{
            id:userId
        }
    })
    if(user?.role === 'creator'){
        return res.status(403).json({
            "success": false,
            "data": null,
            "error": "FORBIDDEN"
        })
    }
    if(!req.body){
        return res.status(400).json({
            "success": false,
            "data": null,
            "error": "INVALID_REQUEST"
        })
    }
    const validatedData = selectedOptionSchema.safeParse(req.body)
    if(!validatedData.success){
        return res.status(400).json({
            "success": false,
            "data": null,
            "error": "INVALID_REQUEST"
        })
    }
    const isSubmitted = await prisma.mcq_submission.findFirst({
        where:{
            userId,
            questionId
        }
    })
    if(isSubmitted){
        return res.status(400).json({
            "success": false,
            "data": null,
            "error": "ALREADY_SUBMITTED"
        })
    }

    const questionExists = await prisma.mcq_question.findFirst({
        where:{
            id:questionId
        }
    })
    if(!questionExists){
        return res.status(404).json({
            "success": false,
            "data": null,
            "error": "QUESTION_NOT_FOUND"
        })
    }

    
    const {selectedOptionIndex} = validatedData.data

    const isCorrect = selectedOptionIndex===questionExists.correctOptionIndex

    const pointsEarned = isCorrect? questionExists.points : 0

    const submission = await prisma.mcq_submission.create({
        data:{
            isCorrect,
            selectedOptionIndex,
            pointsEarned,
            questionId,
            userId
        }
    })
    
    res.status(201).json({
        "success": true,
        "data": {
            "isCorrect": submission.isCorrect,
            "pointsEarned": submission.pointsEarned
        },
        "error": null
    })

    } catch (error) {
        console.error('Error in submitting mcq\n',error)
        res.status(500).json({
            message:'Internal server error'
        })
    }

})

export default router