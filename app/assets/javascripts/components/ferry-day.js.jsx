var FerriesDay = React.createClass({

  componentWillMount: function() {
    var date = new Date();
    this.setState({date: date, route: 'HSB'}, this.updateData);
  },
  getInitialState: function() {
    return({conditions: []})
  },

  render: function() {
    var rows = this.state.conditions.map(function(condition) {
      return <ConditionRow condition={condition} />
    });
    var date = String(this.state.date).slice(0, 15);
    return (
      <div>
        <label>Pick Date: </label><DatePicker initialValue={this.state.date} selectDate={this.selectDate}/>
        <label>Select Route Origin</label><select onChange={this.selectRoute}><option>HSB</option><option>LNG</option></select>
        <h3>Ferries Leaving {this.state.route} on {date}</h3>
        <table>
          <tbody>
            <tr className="bold">
              <td>Condition Time</td>
              <td>Sailing Time</td>
              <td>Percentage Full</td>
            </tr>
            {rows}
          </tbody>
        </table>
      </div>
    )
  },

  selectRoute: function(e) {
    var route = e.target.value;
    this.setState({route: route}, this.updateData);
  },
  selectDate: function(date) {
    this.setState({date: date}, this.updateData);
  },

  updateData: function() {
    var data = {date: this.state.date, route: this.state.route};
    $.ajax({
      type: 'GET',
      url: '/conditions/date',
      data: data,
      success: function(r) {
        this.setState({conditions: r.conditions})
      }.bind(this), error: function(r) {
        console.log(r);
      }
    })
  },


});

var ConditionRow = React.createClass({
  render: function() {
    var c = this.props.condition;
    var created_at = new Date(c.created_at);
  	var hours = created_at.getHours()
  	var minutes = created_at.getMinutes()
  	if (minutes < 10) {
    	minutes = "0" + minutes
    }

    return (
      <tr>
        <td>{hours}:{minutes}</td>
        <td>{c.sailing_time}</td>
        <td>{c.total_percentage}</td>
      </tr>
    )
  }
})
