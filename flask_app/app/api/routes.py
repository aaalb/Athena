from app.api import bp 
from app.models.user import User
from app.extensions import session
from flask import jsonify
from flask_jwt_extended import *
from app.models.exam import Exam
from app.models.student import Student
from app.models.test import Test

@bp.route('/getAppelli', methods=['GET'])
#@jwt_required()
def getAppelli():
   # current_user = get_jwt_identity()
    
    #result = session.query(Test).join(Exam, Test.ExamId==Exam.IdExam).join(Student, Exam.StudentBadgeNumber == Student.BagdeNumber).filter_by(Student.BadgeNumber == current_user)
    result = session.query(Test).all()
    
    return jsonify()
