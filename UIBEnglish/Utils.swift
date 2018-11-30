//
//  Utils.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/29/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    
    
    let baseURLMoodle = ""
    let baseURLDe = ""
    
    
    static func show_message(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
   
    

//
//
//    @FormUrlEncoded
//    @POST("mobile_eng/data.php")
//    Call<EngInformationResponse> getStudentSubjectInformation(
//    @Field("user_id") String user_id);
//
//
//
//
//    @FormUrlEncoded
//    @POST("modules/online_lessons/add_results.php")
//    Call<PostDataResponse> postVocabularyResult(
//    @Field("exercise_id") String ex_id,
//    @Field("user_id") String user_id,
//    @Field("topic_id") String topic_id,
//    @Field("result") int result,
//    @Field("start_time") long start_time,
//    @FieldMap Map<String, Integer> each_result);
//
//    @FormUrlEncoded
//    @POST("modules/online_lessons/add_results.php")
//    Call<PostDataResponse> postTaskResult(
//    @FieldMap Map<String, String> data);
//
//    @FormUrlEncoded
//    @POST("post/user_word_data.php")
//    Call<PostDataResponse> postUnknownWord(
//    @Field("user_id") String user_id,
//    @Field("course_id") String course_id,
//    @Field("word") String word);
//
//    @FormUrlEncoded
//    @POST("post/user_word_data.php")
//    Call<PostDataResponse> changeWordAsKnown(
//    @Field("word_id") String word_id);
//
//    @FormUrlEncoded
//    @POST("post/reading_questions.php")
//    Call<PostDataResponse> postReadingResult(
//    @Field("user_id") String user_id,
//    @Field("topic_id") String topic_id,
//    @Field("result_ans") Integer result_ans,
//    @Field("result_tf") Integer result_tf,
//    @Field("start_time") long start_time);
//
//    @FormUrlEncoded
//    @POST("post/listening_questions.php")
//    Call<PostDataResponse> postListeningResult(
//    @Field("user_id") String user_id,
//    @Field("topic_id") String topic_id,
//    @Field("result_ans") int result_ans,
//    @Field("start_time") long start_time);
//
//    @FormUrlEncoded
//    @POST("post/grammatika_questions.php")
//    Call<PostDataResponse> postGrammarResultNew(
//    @Field("user_id") String user_id,
//    @Field("topic_id") String topic_id,
//    @Field("result_ans") int result_ans,
//    @Field("result_cons") int result_cons,
//    @Field("start_time") long start_time);
//
//    @FormUrlEncoded
//    @POST("mobile/tokens.php")
//    Call<PostDataResponse> sendTokenToServer(
//    @Field("user_id") String user_id,
//    @Field("device_token") String device_token);
//
//    /***
//     *
//     * @param user_id
//     * @return
//     */
//
//    //Get
//    @FormUrlEncoded
//    @POST("post/words_data.php")
//    Call<List<WordCollection>> getStudentWallet(
//    @Field("user_id") String user_id,
//    @Field("course_id") String course_id);
//
//    @FormUrlEncoded
//    @POST("post/get_reading.php")
//    Call<List<Reading>> getReadingArray(
//    @Field("topic_id") String topic_id);
//
//    @FormUrlEncoded
//    @POST("post/get_listening.php")
//    Call<List<Listening>> getListeningArray(
//    @Field("topic_id") String topic_id);
//
//    @FormUrlEncoded
//    @POST("post/get_grammatika.php")
//    Call<List<Grammar>> getGrammarArray(
//    @Field("topic_id") String topic_id);
//
//    @FormUrlEncoded
//    @POST("post/get_user_results.php")
//    Call<ResultStudentTasks> getUserResult(
//    @Field("user_id") String user_id,
//    @Field("course_id") String course_id);
    
    


}
