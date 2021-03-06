<%@ page import="com.soen387.model.Poll" %>
<%@ page import="com.soen387.business.PollManager" %>
<%@ page import="com.soen387.model.Choice" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="com.soen387.business.PollStateException" %>
<%@ page import="com.soen387.business.PollException" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<jsp:useBean id="ManagedPoll" class="com.soen387.model.Poll" scope="request"/>
<jsp:useBean id="poll" class="com.soen387.business.PollManager" scope="request"/>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <title>Polling System - Poll Vote Page</title>


    <% if (ManagedPoll.getStatus() == Poll.PollStatus.valueOf("released")) {%>

    <!--Code taken from: https://developers.google.com/chart/interactive/docs/quick_start-->
    <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">

        // Load the Visualization API and the corechart package.
        google.charts.load('current', {'packages': ['corechart']});

        // Set a callback to run when the Google Visualization API is loaded.
        google.charts.setOnLoadCallback(drawChart);

        // Callback that creates and populates a data table,
        // instantiates the pie chart, passes in the data and
        // draws it.
        function drawChart() {

            // Create the data table.
            let data = new google.visualization.DataTable();
            data.addColumn('string', 'Choice');
            data.addColumn('number', 'Amount');

            data.addRows([
                <%
                    Choice[] choices = ManagedPoll.getChoices();
                    try {
                        Hashtable<Integer, Integer> results = ManagedPoll.getResults();

                        for (int i = 0; i < choices.length; i++) {
                            if (i != 0) out.print("                ");
                            out.print("['" + choices[i].getText() + "', " + results.get(i) + "]");
                            if (i != choices.length - 1) out.print(",");
                            else out.println("");
                        }
                    } catch (PollException e) {
                        e.printStackTrace();
                    }

                %>
            ]);

            // Set chart options
            var options = {
                'title': 'Choices in the Poll',
                'width': 400,
                'height': 300
            };

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }
    </script>
    <% }%>

</head>

<body class="container">

<%@ include file="sharedViews/navbar.jsp" %>
<div class="container">

    <%
        String selectedChoice = request.getParameter("choiceNumber");
        String status = request.getParameter("status");
        if (status != null && (status.equals("new") || status.equals("edit"))) {
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        Your vote has been registered successfully. You PIN for this vote is <strong><%=request.getParameter("pinId")%></strong>.
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <%
        }
    %>


    <h1>Vote on Poll</h1>
    <div class="card">
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/vote/<%=ManagedPoll.getPollId()%>" method="post">
                <input type="hidden" name="poll_id" value="<%=ManagedPoll.getPollId()%>">
                <input type="hidden" name="pinId" value="<%=request.getParameter("pinId")%>">
                <div class="form-group row">
                    <label class="col-md-2 col-form-label">Poll Title</label>
                    <div class="col-md-8">
                        <%= ManagedPoll.getName() %>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-md-2 col-form-label">Poll Question</label>
                    <div class="col-md-8">
                        <%= ManagedPoll.getQuestion() %>
                    </div>
                </div>

                <div>
                    <!--TODO: If updateVote, ensure previous DB vote table choice_number checked. getPinId() doesn't exist.-->
                    <%
                        for (Choice choice : ManagedPoll.getChoices()) {
                            String checked = "";
                            String description = choice.getDescription();
                            if (selectedChoice != null && !selectedChoice.isEmpty() && Integer.parseInt(selectedChoice) == choice.getNumber()) {
                                checked = "checked";
                            }
                            if (description == null){
                                description = "";
                            }else{
                                description = "(" + description + ")";
                            }
                            if (ManagedPoll.getStatus() == Poll.PollStatus.running) {

                    %>
                    <input type="radio" name="choice" value="<%= choice.getNumber() %>" <%= checked %>>
                    <%= choice.getText()%><%= description%><br/>
                    <%
                    } else {
                    %>
                    Choice #<%= choice.getNumber() %>: <%= choice.getText()%><%= description%><br/>
                    <%
                            }
                        }
                    %>
                </div>

                <%
                    if (ManagedPoll.getStatus() == Poll.PollStatus.running) {
                %>
                <input type="submit" value="Submit" class="btn btn-primary float-right"/>
                <%
                    }
                %>
            </form>
        </div>
    </div>
    <% if (ManagedPoll.getStatus() == Poll.PollStatus.valueOf("released")) {%>
    <h2>Results</h2>
    <!--Div that will hold the pie chart-->
    <div id="chart_div"></div>

    <%} else {%>
    <h2>Results will show once the poll is released</h2>
    <%}%>
    <br/>
</div>



<%@ include file="sharedViews/footer.html" %>
<script>
    $( document ).ready(function() {
        history.pushState(null, "", location.href.split("?")[0]);
    });
</script>
</body>
</html>
