package br.ufprconvida.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.Objects;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;


@Document
public class Event implements Serializable{


    private static final long serialVersionUID = 1L;
    @Id
    private String Id;
    private String name;
    private String target;
    private Date date_event;
    private String desc;
    private Date init;
    private Date end;
    private String link;
    private String type;
    

    public Event(String Id, String name, String target, Date date_event, String desc, Date init, Date end, String link, String type) {
        this.Id = Id;
        this.name = name;
        this.target = target;
        this.date_event = date_event;
        this.desc = desc;
        this.init = init;
        this.end = end;
        this.link = link;
        this.type = type;
    }


    public Event() {
    }



    public String getId() {
        return this.Id;
    }

    public void setId(String Id) {
        this.Id = Id;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTarget() {
        return this.target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public Date getDate_event() {
        return this.date_event;
    }

    public void setDate_event(Date date_event) {
        this.date_event = date_event;
    }

    public String getDesc() {
        return this.desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public Date getInit() {
        return this.init;
    }

    public void setInit(Date init) {
        this.init = init;
    }

    public Date getEnd() {
        return this.end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }

    public String getLink() {
        return this.link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getType() {
        return this.type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof Event)) {
            return false;
        }
        Event event = (Event) o;
        return Objects.equals(Id, event.Id) && Objects.equals(name, event.name) && Objects.equals(target, event.target) && Objects.equals(date_event, event.date_event) && Objects.equals(desc, event.desc) && Objects.equals(init, event.init) && Objects.equals(end, event.end) && Objects.equals(link, event.link) && Objects.equals(type, event.type);
    }

    @Override
    public int hashCode() {
        return Objects.hash(Id, name, target, date_event, desc, init, end, link, type);
    }

    
}