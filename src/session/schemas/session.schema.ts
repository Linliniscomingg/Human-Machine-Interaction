
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import mongoose, { HydratedDocument, Types } from 'mongoose';
import { Lesson } from 'src/lesson/schemas/lesson.schema';
import { User } from 'src/users/schemas/user.schema';

export type SessionDocument = HydratedDocument<Session>;

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
export class Session {
    @Prop({ required: true })
    name: string

    @Prop({ type: mongoose.Schema.Types.ObjectId, ref: Lesson.name, default: [] })
    lessonId: Types.ObjectId[]

    @Prop({ type: mongoose.Schema.Types.ObjectId, ref: User.name, default: [] })
    userId: Types.ObjectId[]

    @Prop({default: 0})
    excerciseFinish: number

    @Prop({default: false})
    isFinished: boolean
}

export const SessionSchema = SchemaFactory.createForClass(Session);

SessionSchema.pre<SessionDocument>(/^find/, function (next) {
    this.populate({
        path: "userId",
        select: "-__v -createdAt -updatedAt -_id",
    });
    next();
})

SessionSchema.pre<SessionDocument>(/^find/, function (next) {
    this.populate({
        path: "lessonId",
        select: "-__v -createdAt -updatedAt -_id",
    })
    next();
})

