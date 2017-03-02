package org.bk.producer.service;

import org.bk.producer.domain.Message;
import org.bk.producer.domain.MessageAcknowledgement;
import rx.Single;

public interface MessageHandlerService {
    Single<MessageAcknowledgement> handleMessage(Message message);
}
