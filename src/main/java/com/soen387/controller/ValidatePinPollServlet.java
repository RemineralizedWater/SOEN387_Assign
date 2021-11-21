package com.soen387.controller;


import com.soen387.business.PollManager;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ValidatePinPollServlet", value = {"/ValidatePinPoll", "/validatepinpoll"})
public class ValidatePinPollServlet extends HttpServlet {
    PollManager pollManager = new PollManager();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String enteredPinId = request.getParameter("pinId");
        String enteredPollId = request.getParameter("pollId");
        //TODO: need to pre-validate if pin_id & poll_id exist

        if (enteredPinId == null) {
            //TODO: Search DB if poll exists (used hardcode to test)
            boolean pollExists = true;
            if (pollExists) {
                //TODO: Do vote with createVote (generate new pin)
                String returnUrl = request.getParameter("returnurl");
                if (returnUrl != null && !returnUrl.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/" + returnUrl);
                } else {
                    response.sendRedirect(request.getContextPath());
                }
            } else {
                //TODO: Handle invalid Poll entry
                throw new IOException();
            }
        } else {
            int choiceNumber = pollManager.getChoiceNumber(enteredPinId, enteredPollId);
            boolean voteExists = false;
            if (choiceNumber > -1){
                voteExists = true;
            }
            //TODO: Search DB if pin & poll combo exists (used hardcore to test)
            if (voteExists) {

                request.setAttribute("choiceNumber", choiceNumber);
                request.setAttribute("pinId", enteredPinId);
                //TODO: Do vote with updateVote (use supplied pin)

//                RequestDispatcher dispatcher = request.getRequestDispatcher("/vote/" + enteredPollId);
//                dispatcher.forward(request, response);

                response.sendRedirect(request.getContextPath() + "/vote/" + enteredPollId + "?pinId=" + enteredPinId + "&choiceNumber=" + choiceNumber);
            } else {
                //TODO: Handle invalid Pin & Poll entry
                throw new IOException();
            }
        }
    }

    /*
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher(Constants.ViewsBaseLink + "index.jsp");
        dispatcher.forward(request, response);
    }*/
}
