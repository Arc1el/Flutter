const {meeting} = require("../models/meeting.model");
const {meetingUser} = require("../models/meeting-user.model");

async function getAllMeetingUSers(meetId, callback){
    meetingUser.find({meetingId : meetId})
    .then((response) => {
        return callback(null, response);
    })
    .catch((error) => {
        return callback(error);
    });
}

async function startMeeting(params, callback){
    const meetingUserModel = new meetingUser(params);

    meetingUserModel.save()
    .then(async (resposne) => {
        await meeting.findOneAndUpdate({ id : params.meetingId })
    })
}