
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import mongoose, { HydratedDocument, Types } from 'mongoose';

export type ExerciseDocument = HydratedDocument<Exercise>;

@Schema(
    {
        timestamps: true,
        toJSON: {
            virtuals: true,
            transform: (_, ret) => {
                delete ret._id;
                delete ret.__v;
                delete ret.password;
                return ret;
            }
        }
    }
)
export class Exercise {
    @Prop({ required: true, trim: true})
    name: string

    @Prop({ required: true})
    description: string

    @Prop()
    imageUrl: string

    @Prop()
    videoUrl: string

    @Prop({type: [String], default: []})
    guideSteps: string[]

    @Prop({type: [String], default: []})
    tags: string[]

    @Prop({type: mongoose.Schema.Types.ObjectId})
    createdBy: Types.ObjectId

    @Prop()
    duration: number

    @Prop()
    numberOfReps: number

    @Prop()
    difficulty: string
}

export const ExerciseSchema = SchemaFactory.createForClass(Exercise);

