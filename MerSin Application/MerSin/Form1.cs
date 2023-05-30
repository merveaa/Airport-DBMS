using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MerSin
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        NpgsqlConnection connect = new NpgsqlConnection("server=localHost;port=5432;UserId = postgres;" + "password=Password4; database=AirportMersin");

        private void button1_Click(object sender, EventArgs e) //search
        {
            string query = "select * from \"Passenger\"";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            //connect.Close();
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void button2_Click(object sender, EventArgs e)  //insert
        {
            connect.Open();
            NpgsqlCommand command1 = new NpgsqlCommand("insert into \"Passenger\" values (@passengerid, @name, @surname, @gender, @age, @identitynumber)", connect);
            command1.Parameters.AddWithValue("@passengerid", int.Parse(textBox1.Text));
            command1.Parameters.AddWithValue("@name", textBox2.Text);
            command1.Parameters.AddWithValue("@surname", textBox3.Text);
            command1.Parameters.AddWithValue("@gender", textBox4.Text);
            command1.Parameters.AddWithValue("@age", int.Parse(textBox5.Text));
            command1.Parameters.AddWithValue("@identitynumber", textBox6.Text);
            command1.ExecuteNonQuery();
            connect.Close();
            MessageBox.Show("Passenger insert operation has been done successfully");
        }

        private void button3_Click(object sender, EventArgs e)  //update
        {
            connect.Open();
            NpgsqlCommand command2 = new NpgsqlCommand("update \"Passenger\" set \"Name\"=@name, \"Surname\"=@surname,\"Gender\"=@gender, \"Age\"=@age, \"IdentityNumber\"=@identitynumber where \"PassengerID\"=@passengerid", connect);
            command2.Parameters.AddWithValue("@passengerid", int.Parse(textBox1.Text));
            command2.Parameters.AddWithValue("@name", textBox2.Text);
            command2.Parameters.AddWithValue("@surname", textBox3.Text);
            command2.Parameters.AddWithValue("@gender", textBox4.Text);
            command2.Parameters.AddWithValue("@age", int.Parse(textBox5.Text));
            command2.Parameters.AddWithValue("@identitynumber", textBox6.Text);
            command2.ExecuteNonQuery();

            MessageBox.Show("Do you want to update the Passenger? ", "Information", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            connect.Close();
        }

        private void button4_Click(object sender, EventArgs e)  //delete
        {
            connect.Open();
            NpgsqlCommand command3 = new NpgsqlCommand("delete from \"Passenger\" where \"PassengerID\"=@passengerid", connect);
            command3.Parameters.AddWithValue("@passengerid", int.Parse(textBox1.Text));
            command3.ExecuteNonQuery();
            connect.Close();
            MessageBox.Show("Passenger delete operation has been done successfully");
        }

        private void button5_Click(object sender, EventArgs e)  //search
        {
            string query = "select * from \"Ticket\"";
            NpgsqlDataAdapter adapt = new NpgsqlDataAdapter(query, connect);
            DataSet ds = new DataSet();
            adapt.Fill(ds);
            //connect.Close();
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void button6_Click(object sender, EventArgs e)  //insert
        {
            connect.Open();
            NpgsqlCommand command4 = new NpgsqlCommand("insert into \"Ticket\" values (@ticketid, @seatnumber, @price, @passengerid, @flightid, @tickettype)", connect);
            command4.Parameters.AddWithValue("@ticketid", int.Parse(textBox7.Text));
            command4.Parameters.AddWithValue("@seatnumber", textBox8.Text);
            command4.Parameters.AddWithValue("@price", int.Parse(textBox9.Text));
            command4.Parameters.AddWithValue("@passengerid", int.Parse(textBox10.Text));
            command4.Parameters.AddWithValue("@flightid", int.Parse(textBox11.Text));
            command4.Parameters.AddWithValue("@tickettype", textBox12.Text);
            command4.ExecuteNonQuery();
            connect.Close();
            MessageBox.Show("Ticket insert operation has been done successfully");
        }

        private void button7_Click(object sender, EventArgs e) //update
        {

            connect.Open();
            NpgsqlCommand command5 = new NpgsqlCommand("update \"Ticket\" set \"SeatNumber\"=@seatnumber, \"Price\"=@price, \"PassengerID\"=@passengerid, \"FlightID\"=@flightid, \"TicketType\"=@tickettype where \"TicketID\"=@ticketid", connect);
            command5.Parameters.AddWithValue("@ticketid", int.Parse(textBox7.Text));
            command5.Parameters.AddWithValue("@seatnumber", textBox8.Text);
            command5.Parameters.AddWithValue("@price", int.Parse(textBox9.Text));
            command5.Parameters.AddWithValue("@passengerid", int.Parse(textBox10.Text));
            command5.Parameters.AddWithValue("@flightid", int.Parse(textBox11.Text));
            command5.Parameters.AddWithValue("@tickettype", textBox12.Text);
            command5.ExecuteNonQuery();
            MessageBox.Show("Do you want to update the Ticket? ", "Information", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            connect.Close();
        }

        private void button8_Click(object sender, EventArgs e)  //delete
        {
            connect.Open();
            NpgsqlCommand command6 = new NpgsqlCommand("delete from \"Ticket\" where \"TicketID\"=@ticketid", connect);
            command6.Parameters.AddWithValue("@ticketid", int.Parse(textBox7.Text));
            command6.ExecuteNonQuery();
            connect.Close();
            MessageBox.Show("Ticket delete operation has been done successfully");
        }
    }
}
