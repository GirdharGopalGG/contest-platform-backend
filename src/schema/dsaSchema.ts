import {z} from 'zod'
export const dsaSchema = z.object({
    title:z.string(),
    description:z.string(),
    tags:z.array(z.string()),
    points:z.number(),
    timeLimit:z.number(),
    memoryLimit:z.number(),
    testCases:z.array(z.object({
        input:z.string(),
        expectedOutput:z.string(),
        isHidden:z.boolean()
    }).strict()).min(1)

})
.strict()