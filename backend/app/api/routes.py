from app.api import bp 
from app.models.user import User
from app.extensions import session
from flask import jsonify
from flask_jwt_extended import *
from app.models.exam import Exam
from app.models.student import Student
from app.models.test import Test

#get TO-DO exams
@bp.route('/getTODOexams', methods=['POST'])
@jwt_required()
def getAppelli():
   current_user = get_jwt_identity()

   result = session.query(Test).join(Exam, onclause=Test.examid == Exam.idexam).join(Student, Exam.studentbadgenumber == Student.badgenumber).filter(Student.badgenumber == current_user)

   return jsonify(str(result.first()))
