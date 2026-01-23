import express, { Request, Response } from 'express'
import { prisma } from '../lib/prisma.js'
const router = express.Router()

router.get('/:problemId',async(req:Request,res:Response)=>{
    const problemId = Number(req.params.problemId)
    if(isNaN(problemId)){
        return res.status(404).json({
            "success": false,
            "data": null,
            "error": "PROBLEM_NOT_FOUND"
        })
    }
    const problem = await prisma.dsa_problem.findFirst({
        where:{
            id:problemId
        }
    })
    if(!problem){
        return res.status(404).json({
            "success": false,
            "data": null,
            "error": "PROBLEM_NOT_FOUND"
        })
    }

    const testCases = await prisma.test_case.findMany({
        where:{
            problemId,
            isHidden:false
        },
        select:{
            input:true,
            expectedOutput:true
        }
    })

    res.status(200).json({
        "success": true,
        "data": {
            "id": problem.id,
            "contestId": problem.contestId,
            "title": problem.title,
            "description": problem.description,
            "tags": problem.tags,
            "points": problem.points,
            "timeLimit": problem.timeLimit,
            "memoryLimit": problem.memoryLimit,
            "visibleTestCases":testCases
            
        },
        "error": null
    })
    
})

export default router