package org.bk.producer.service;

import org.bk.producer.domain.Message;
import org.bk.producer.domain.MessageAcknowledgement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import rx.Single;

import java.util.concurrent.TimeUnit;

@Service
public class MessageHandlerServiceImpl implements MessageHandlerService {
    private static final Logger logger = LoggerFactory.getLogger(MessageHandlerServiceImpl.class);


    private final String replyMessage;

    @Autowired
    public MessageHandlerServiceImpl(@Value("${reply.message}") String replyMessage) {
        this.replyMessage = replyMessage;
    }

    @Override
    public Single<MessageAcknowledgement> handleMessage(Message message) {
        logger.info("About to Acknowledge");

        return Single.just(message)
                .delay(message.getDelayBy(), TimeUnit.MILLISECONDS)
                .flatMap(msg -> {
                    if (msg.isThrowException()) {
                        return Single.error(new IllegalStateException("Throwing a deliberate exception!"));
                    }
                    return Single.just(new MessageAcknowledgement(message.getId(), message.getPayload(), this.replyMessage));
                });

    }


}
