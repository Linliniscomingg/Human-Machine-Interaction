
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import mongoose, { HydratedDocument, Types } from 'mongoose';
import { Exercise } from 'src/exercise/schemas/exercise.schema';

export type LessonDocument = HydratedDocument<Lesson>;

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
export class Lesson {
    @Prop({ required: true })
    name: string

    @Prop({ required: true })
    description: string

    @Prop()
    difficulty: string

    @Prop()
    imgUrl: string

    @Prop()
    videoUrl: string

    @Prop()
    bodyPart: string

    @Prop()
    duration: number

    @Prop({ type: [{ type: mongoose.Schema.Types.ObjectId, ref: Exercise.name }], default: [] })
    exercises: Types.ObjectId[]
}

export const LessonSchema = SchemaFactory.createForClass(Lesson);

LessonSchema.pre<LessonDocument>(/^find/, function (next) {
    this.populate({
        path: "exercises",
        select: "-__v -createdAt -updatedAt -_id",
    });
    next();
})

